---
cairn: change
id: vim9-v2-rewrite
status: landed
created: 2026-09-28
---

# Vim9-only rewrite on Himalaya CLI v2

## Why

The plugin targets the Himalaya CLI v1 contract, which v2 broke: `folder` became `mailbox`, `--output json` became `--json`, `envelope list` no longer takes a query, templates are gone, and `message send` no longer compiles MML. The job layer still treats any stderr output as a failure, while v2 prints data and errors on stdout, logs on stderr, and signals failure through the exit code only (#32 fixed Neovim alone).

Two PRs tried to patch this piecemeal. #32 (merged on master) fixed the Neovim exit code. #33 (against `v2`) aligns a few commands but ships an attachment helper that sends literal `<#part>` lines, and flags the wrong message as answered when replying from the listing. Rewriting the files it touches right after merging it would be churn, so it is superseded by this change: close it with thanks, credit its findings (list/search split, box-drawing syntax, cell-based ID parsing, `--seen`) in the CHANGELOG, and invite its author to review the rewrite.

Maintaining two runtimes doubles the job layer, the pickers and the testing surface. Neovim has several community mail plugins; Vim has none comparable. The plugin becomes Vim9-only, and the README points Neovim users to community plugins.

## What

A 2.0 release of himalaya-vim, written in Vim9 script, requiring Vim 9.1 and Himalaya CLI v2.

**Runtime.** Every file is `vim9script`, autoloaded through `import autoload`. Neovim support is removed: `autoload/himalaya/job/neovim.vim`, the whole `lua/` tree, and the Telescope and fzf-lua pickers. The native picker moves to `popup_menu()`, and the fzf.vim picker is kept since it works in Vim. Mappings use `<Plug>` plus `<ScriptCmd>`.

**Job layer.** One `job_start()` per request with an argv list, never `/bin/sh -c`, so a query or a path is one argument without shell escaping (this also keeps quoted search patterns intact, see pimalaya/himalaya#768). Input goes through `ch_sendraw()` instead of the ` -- ` split hack. State lives in a per-job closure, not in script-level `s:stdout`/`s:stderr`, so concurrent requests cannot mix. Completion waits for both `exit_cb` and `close_cb`. Exit 0 hands stdout to the caller. Non-zero decodes the stdout `{"error", "sources"}` report and shows it, falling back to raw stdout, with stderr appended as context. The `RUST_LOG=off` prefix goes away.

**CLI v2 surface.** `account list`, `mailbox list`, `envelope list` (empty query) or `envelope search <query>`, `message read --seen`, `flag add/remove`, `message copy/move/delete`, `attachment download`, `message compose/reply/forward`, `message send`, `message add -f draft`. JSON keys are camelCase.

**Writing.** Hand-edited messages with attachments are what MML is for, and Vim has no MML support, so composition is delegated to the CLI's flags instead:

- The buffer is prefilled with the template `message compose/reply/forward` prints (no `--send`): the `From`, `To`, `Cc`, `Bcc` and `Subject` headers, a blank line, then the plain text body, quote included. The source ID and the command are stored on the buffer.
- A mapping prompts for a file (with completion) and adds it to the buffer's attachment list. A second mapping opens a dedicated attachment buffer listing the files, where they are added and removed; its count shows in the writing buffer's status line.
- On send, the plugin parses the header block into `--from`, `--to`, `--cc`, `--bcc` and `--subject`, writes the body to a temporary file for `--body-file`, adds one `--attach` per file, and runs the stored command with `--send` (`message reply <id>` or `message forward <id>` keeps `In-Reply-To`, `References` and the source). Saving a draft is the same call with `--save <drafts>` instead of `--send`.
- Headers other than the five above are not carried. After a successful reply send, the plugin flags the stored source ID `answered`.

This needs two CLI additions:

- Reply and forward always quote the source (`PostingStyle` is `top` or `bottom`), so a body that already holds the edited quote would carry it twice. A `none` posting style (or `--no-quote`) lets the plugin send the buffer body as written, which also keeps interleaved replies possible.
- The template compose, reply and forward print is wire format (`write_to_vec`): RFC 2047 encoded words, a quoted-printable or base64 body, plus `Date`, `Message-ID`, `MIME-Version` and `Content-*` headers. Under `--json`, without `--send` nor `--save`, they SHALL print the decoded fields instead (`from`, `to`, `cc`, `bcc`, `subject`, `body`), which the plugin lays out as the buffer. That `body` SHALL leave out the signature, which the CLI appends from the account config on `--send` or `--save`.

The plugin is a thin layer over the CLI: identity, signature, mailbox aliases and every other account option live in the CLI config, never in plugin options.

**Listing.** Syntax and ID parsing derive columns from the header row names (`ID`, `FLAGS`, optional `ATT`, `SUBJECT`, `FROM`/`TO`, `DATE`, `SIZE`) instead of positions, and accept both the default UTF-8 preset and ASCII presets.

**Resuming a draft.** Editing a message from the drafts mailbox opens a compose buffer prefilled from `message read --json` (decoded headers and text body), and runs `attachment download --json --dir <buffer temp dir> <id>` to fill the attachment list with the returned paths. From there it sends and saves like any compose buffer, and the old draft is deleted once the send or the new save succeeds. The buffer's temp dir is removed when the buffer is wiped.

## Known limit

A resumed draft goes through `message compose`, which takes no `In-Reply-To` nor `References`, so a resumed reply loses its threading. Lifting it needs those headers as compose flags in the CLI, left for after 2.0.

## What this is not

No HTML rendering, no MML, no threading view beyond folding quoted lines, no Neovim support.
