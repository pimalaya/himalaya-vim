---
cairn: log
change: vim9-v2-rewrite
landed: 2026-09-28
---

# Vim9-only rewrite on Himalaya CLI v2

The plugin was rewritten in Vim9 script against Himalaya CLI v2, and Neovim support dropped with the Lua code and the Telescope and fzf-lua pickers. It supersedes #33, whose findings (list/search split, box-drawing tables, cell-based ids, `--seen`) it keeps.

## What landed

**One module per domain.** `cli` runs the jobs, `account`, `mailbox`, `envelope`, `message` and `compose` drive the commands, `picker` and `keybinds` serve them. Each request is one job over an argv list with its own state, completed once both its exit and close callbacks fired. The exit code alone tells a failure, whose stdout report is decoded and shown, stderr following as logs.

**Composition goes through the CLI.** Vim has no MML, so a writing buffer holds the decoded template of `message compose/reply/forward --json` and hands it back through their flags, with `--posting-style none` for reply and forward and one `--attach` per file of the buffer's list. Both CLI additions landed in himalaya the same day, along with keeping envelope ids whole under `--max-width`, found when a Maildir id came out truncated. Drafts are saved with an empty `--signature`, so a resumed draft does not carry it twice.

**Resuming a message** reads it with `message read --json`, downloads its attachments next to the buffer, and deletes the original only once the resumed one is sent or saved. Without a `trash` alias the CLI refuses that deletion, which leaves the original in place.

**Checked** by a headless suite against a stub CLI (`tests/run.vim`, seven cases, mutation-checked), and end to end against the real CLI on a throwaway Maildir: listing a Maildir id, resuming a draft, saving it without signature.

## Capabilities moved

- [runtime](../spec/runtime.md): added *Vim9 runtime*, *Pickers*.
- [cli](../spec/cli.md): added *CLI contract*, *Config lives in the CLI*.
- [listing](../spec/listing.md): added *Envelope listing*.
- [writing](../spec/writing.md): added *Plain text writing*, *Resuming a message*.
