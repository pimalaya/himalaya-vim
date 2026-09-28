---
cairn: tasks
change: vim9-v2-rewrite
---

# Tasks

## 0. Housekeeping

- [ ] Close #33 as superseded, crediting its findings.
- [ ] Merge master (with #32) into `v2`, then rebase the `wip` commit or fold it into this rewrite.
- [ ] Land a `none` posting style (or `--no-quote`) on himalaya `message reply` and `message forward`.
- [ ] Land a decoded JSON template (`from`, `to`, `cc`, `bcc`, `subject`, `body` without the signature) on himalaya `message compose/reply/forward --json` without `--send`/`--save`.
- [ ] Decide how the old draft goes on resume: `message delete` (a copy lands in the trash) or a permanent removal.

## 1. Runtime and job layer

- [ ] Drop `autoload/himalaya/job/neovim.vim`, `lua/`, the Telescope and fzf-lua pickers.
- [ ] Guard `plugin/himalaya.vim` on `v:version >= 901` with a clear error; drop the `RUST_LOG=off` prefix.
- [ ] Rewrite `job`, `request`, `log` in Vim9: argv lists, per-job state, `exit_cb` + `close_cb` join, stdout JSON error decoding.

## 2. Reading domains

- [ ] `account` and `mailbox` domains on `account list` / `mailbox list --json`, camelCase keys.
- [ ] Envelope listing: `envelope list` or `envelope search <query>`, paging, `--max-width`, `--page-size`.
- [ ] Header-driven column mapping for ID parsing and syntax; UTF-8 and ASCII presets.
- [ ] `message read --seen`, quote folding, `attachment download`.
- [ ] Flags, copy, move, delete, including visual-range multi-ID.

## 3. Writing

- [ ] Compose, reply, forward buffers prefilled from the decoded JSON templates; command and source ID stored on the buffer.
- [ ] Attach mapping (file prompt with completion) and a dedicated attachment buffer to add and remove files; count in the `winbar`.
- [ ] Header block parser into `--from/--to/--cc/--bcc/--subject`, body to `--body-file`, one `--attach` per file.
- [ ] Send through the stored command with `--send` (and the `none` posting style for reply and forward), then `flag add -f answered <id>` on a successful reply; temp files always deleted.
- [ ] Save draft: the same call with `--save <drafts>`.
- [ ] Resume draft: `message read --json` into a compose buffer, `attachment download --json --dir <temp>` into its list, old draft deleted after a successful send or save, temp dir removed on wipe.

## 4. Pickers and mappings

- [ ] Native picker on `popup_menu()`; fzf.vim picker in Vim9; unknown picker values fail with the list of valid ones.
- [ ] Mappings through `<Plug>` + `<ScriptCmd>`; keep the existing default keys; keep `:HimalayaFolder(s)` aliases one release.

## 5. Tests, docs, release

- [ ] Test harness: `vim -Nu NONE -es` with `assert_*`, against a stub `himalaya` script returning canned stdout, stderr and exit codes; wired into the nix devshell.
- [ ] `doc/himalaya.txt` help file; README requirements (Vim 9.1, Himalaya v2) and a pointer to Neovim community plugins.
- [ ] CHANGELOG: Removed Neovim support, Changed CLI v2, Fixed stderr-as-failure and answered flag.
- [ ] Fold the delta into `cairn/spec/`, write the log entry, set `status: landed`.
