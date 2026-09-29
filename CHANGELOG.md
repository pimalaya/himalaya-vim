# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Added `:HimalayaAccounts` and `gA`, an account picker, with the `g:himalaya_account_picker` option.
- Added option `g:himalaya_config_path` to pass configuration files to the CLI.
- Added `ge` (`<Plug>(himalaya-email-edit)`) to resume a message, a draft included, as a new one with its attachments.
- Added `gA` (`<Plug>(himalaya-email-attachments)`) in writing buffers, listing the attached files for editing, and an attachment count in their status line.
- Added a test suite running the plugin against a stub CLI.

### Changed

- **BREAKING**: rewrote the plugin in Vim9 script, requiring Vim 9.1.
- **BREAKING**: aligned the plugin with Himalaya CLI v2, which it now requires.

  Accounts, signatures and mailbox aliases come from the CLI configuration only. Unset, the account and the mailbox are the CLI defaults rather than `INBOX`.

- **BREAKING**: composition goes through the CLI composer flags instead of templates and MML.

  A writing buffer holds the plain text headers and body, and attachments live in a list next to it. `:write` asks to send, save as a draft or cancel, instead of prompting on leaving the buffer.

- Renamed the `folder` options, commands and mappings to `mailbox`, keeping `:HimalayaFolders` and `:HimalayaFolder` as aliases.
- Replaced the native pickers by a popup menu, and made fzf.vim the default picker when installed.

### Removed

- **BREAKING**: removed Neovim support, the Lua code, and the Telescope and fzf-lua pickers with `g:himalaya_folder_picker_telescope_preview`.
- Removed the reply-all and open-in-browser keybinds, which CLI v2 no longer backs.
- Removed option `g:himalaya_custom_email_flags`: CLI v2 flags are `seen`, `answered`, `flagged` and `draft`.

### Fixed

- Fixed a successful command failing because the CLI logged on stderr: only the exit code tells a failure now, and its error report is shown.
- Fixed the `answered` flag landing on the last read message instead of the replied one.
- Fixed envelope ids other than numbers, such as Maildir file names, not being recognized in the listing.
- Fixed concurrent commands mixing their outputs.
- Fixed copy, move and delete not working when using multiple ids. [#147]
- Fixed too long JSON string not being processed. [#98]

## [0.7.1]

### Added

- Replaced system calls by async jobs [cli#230].
- Set email listing page size to windows height [cli#46].

### Fixed

- Fixed `cancel` reply after exiting the email edition buffer.

### Changed

- The Vim plugin has been removed from the
  [monorepo](https://github.com/soywod/himalaya) and extracted into
  its own [repo](https://git.sr.ht/~soywod/himalaya-vim). It was a
  good occasion to refactor the code and refresh the API. Here the
  list of the breaking changes:
  - config `g:himalaya_mailbox_picker` became `g:himalaya_folder_picker`
  - config `g:himalaya_telescope_preview_enabled` became `g:himalaya_folder_picker_telescope_preview`
  - keybind `himalaya-mbox-input` became `himalaya-folder-select`
  - keybind `himalaya-mbox-prev-page` became `himalaya-folder-select-previous-page`
  - keybind `himalaya-mbox-next-page` became `himalaya-folder-select-next-page`
  - keybind `himalaya-msg-read` became `himalaya-email-read`
  - keybind `himalaya-msg-write` became `himalaya-email-write`
  - keybind `himalaya-msg-reply` became `himalaya-email-reply`
  - keybind `himalaya-msg-reply-all` became `himalaya-email-reply-all`
  - keybind `himalaya-msg-forward` became `himalaya-email-forward`
  - keybind `himalaya-msg-copy` became `himalaya-email-copy`
  - keybind `himalaya-msg-move` became `himalaya-email-move`
  - keybind `himalaya-msg-delete` became `himalaya-email-delete`
  - keybind `himalaya-msg-attachments` became `himalaya-email-download-attachments`
  - keybind `himalaya-msg-add-attachment` became `himalaya-email-add-attachment`

[#21]: https://github.com/pimalaya/himalaya-vim/issues/21

[cli#46]: https://github.com/pimalaya/himalaya/issues/46
[cli#230]: https://github.com/pimalaya/himalaya/issues/230
