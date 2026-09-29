---
cairn: spec
capability: cli
status: current
---

# CLI

## Requirements

### Requirement: CLI contract
The plugin SHALL target Himalaya CLI v2. It SHALL run the CLI without a shell, one job and one argv list per request, with its own state, and a request SHALL complete once both the exit and the close callbacks fired. The exit code SHALL be the only failure signal: on failure, the plugin SHALL show the `error` and `sources` of the JSON report printed on stdout, falling back to raw stdout, then stderr as logs. Stderr SHALL never fail a request.

### Requirement: Config lives in the CLI
Account options (identity, signature, mailbox aliases, downloads directory) SHALL come from the Himalaya CLI config only, an unset account or mailbox leaving the CLI default. The plugin SHALL carry options about the editor alone: executable and config paths, pickers, confirmation, contact completion.
