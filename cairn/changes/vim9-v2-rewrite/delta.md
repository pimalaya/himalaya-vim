---
cairn: delta
change: vim9-v2-rewrite
---

# Delta

## ADDED Requirements

### Requirement: Vim9 runtime
The plugin SHALL be written in Vim9 script and require Vim 9.1. It SHALL NOT support Neovim nor ship Lua code, and SHALL stop loading with a message naming the requirement on an older Vim.

### Requirement: CLI contract
The plugin SHALL target Himalaya CLI v2. It SHALL run the CLI without a shell, one job and one argv list per request, with its own state, and a request SHALL complete once both the exit and the close callbacks fired. The exit code SHALL be the only failure signal: on failure, the plugin SHALL show the `error` and `sources` of the JSON report printed on stdout, falling back to raw stdout, then stderr as logs. Stderr SHALL never fail a request.

### Requirement: Config lives in the CLI
Account options (identity, signature, mailbox aliases, downloads directory) SHALL come from the Himalaya CLI config only, an unset account or mailbox leaving the CLI default. The plugin SHALL carry options about the editor alone: executable and config paths, pickers, confirmation, contact completion.

### Requirement: Envelope listing
An empty query SHALL list through `envelope list` and a non-empty one search through `envelope search`, the query passed as one argument. The id of a row SHALL be read from its first cell, whatever it holds. Columns SHALL be highlighted by the names of the header row and by virtual column, so optional columns and any table preset highlight right.

### Requirement: Plain text writing
Compose, reply and forward buffers SHALL be prefilled from the decoded `--json` template of the CLI composers and edited as plain text, without MML: the `From`, `To`, `Cc`, `Bcc` and `Subject` headers, a blank line, then the body. Any other header SHALL be refused. Attachments SHALL live in a list next to the buffer, managed through a file prompt and an editable attachment buffer, never as body text.

Sending and saving SHALL go through the same composer with flags: the headers as flags, the body as `--body-file`, reply and forward with `--posting-style none`, one `--attach` per file. A draft SHALL be saved to the `drafts` alias with an empty `--signature`, the configured one being appended when it is finally sent. After a successful reply send, the plugin SHALL flag the replied message `answered`, its id taken from the buffer.

### Requirement: Resuming a message
Editing a message SHALL open a compose buffer from its `message read --json` output, with its attachments downloaded to a directory removed along with the buffer. The original SHALL be deleted through `message delete` once the resumed message is sent or saved, and only then.

### Requirement: Pickers
The account and mailbox pickers SHALL be the native popup menu or fzf.vim, fzf.vim by default when installed.
