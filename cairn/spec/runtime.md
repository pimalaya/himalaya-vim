---
cairn: spec
capability: runtime
status: current
---

# Runtime

## Requirements

### Requirement: Vim9 runtime
The plugin SHALL be written in Vim9 script and require Vim 9.1. It SHALL NOT support Neovim nor ship Lua code, and SHALL stop loading with a message naming the requirement on an older Vim.

### Requirement: Pickers
The account and mailbox pickers SHALL be the native popup menu or fzf.vim, fzf.vim by default when installed.
