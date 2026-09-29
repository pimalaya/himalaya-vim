---
cairn: spec
capability: writing
status: current
---

# Writing

## Requirements

### Requirement: Plain text writing
Compose, reply and forward buffers SHALL be prefilled from the decoded `--json` template of the CLI composers and edited as plain text, without MML: the `From`, `To`, `Cc`, `Bcc` and `Subject` headers, a blank line, then the body. Any other header SHALL be refused. Attachments SHALL live in a list next to the buffer, managed through a file prompt and an editable attachment buffer, never as body text.

Sending and saving SHALL go through the same composer with flags: the headers as flags, the body as `--body-file`, reply and forward with `--posting-style none`, one `--attach` per file. A draft SHALL be saved to the `drafts` alias with an empty `--signature`, the configured one being appended when it is finally sent. After a successful reply send, the plugin SHALL flag the replied message `answered`, its id taken from the buffer.

### Requirement: Resuming a message
Editing a message SHALL open a compose buffer from its `message read --json` output, with its attachments downloaded to a directory removed along with the buffer. The original SHALL be deleted through `message delete` once the resumed message is sent or saved, and only then.
