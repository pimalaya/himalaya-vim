---
cairn: delta
change: vim9-v2-rewrite
---

# Delta

## ADDED Requirements

### Requirement: Vim9 runtime
The plugin SHALL be written in Vim9 script and require Vim 9.1. It SHALL NOT support Neovim nor ship Lua code, and SHALL fail at load time with a message naming the requirement on an older Vim.

### Requirement: CLI contract
The plugin SHALL target Himalaya CLI v2. It SHALL run the CLI without a shell, one argv list per request, and treat the exit code as the only failure signal. On failure it SHALL show the `error` and `sources` of the JSON report printed on stdout, falling back to raw stdout; stderr carries logs and SHALL never fail a request.

### Requirement: Config lives in the CLI
Account options (identity, signature, mailbox aliases, downloads directory) SHALL come from the Himalaya CLI config only. The plugin SHALL carry options about the editor alone: executable and config paths, pickers, mappings.

### Requirement: Envelope listing
An empty query SHALL list through `envelope list` and a non-empty one search through `envelope search`. Columns SHALL be located by the header row names, so ID parsing and highlighting follow optional columns and any table preset.

### Requirement: Plain text writing
Compose, reply and forward buffers SHALL be prefilled from the CLI template and edited as plain text, without MML. Attachments SHALL be managed through a file prompt and a dedicated attachment buffer, never as body text. Sending and saving SHALL go through `message compose/reply/forward` flags: the `From`, `To`, `Cc`, `Bcc` and `Subject` headers as flags, the body as `--body-file` sent without an extra quote, one `--attach` per file. After a successful send of a reply, the plugin SHALL flag the source message `answered`, the ID being taken from the buffer. Resuming a draft SHALL restore its attachments into the list and SHALL delete the old draft once the send or the new save succeeds.

### Requirement: Pickers
The account and mailbox pickers SHALL be the native popup menu or fzf.vim.
