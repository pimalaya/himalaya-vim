# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Added support for `fzf-lua` as a mailbox picker.
- Added option `g:himalaya_config_path` to customize the TOML configuration file.
- Implemented `himalaya#domain#email#add_attachment()` for the `<plug>(himalaya-email-add-attachment)` mapping.
- Added backward compatibility aliases `:HimalayaFolders` and `:HimalayaFolder`, and config fallback for `g:himalaya_folder_picker`.

### Changed

- Aligned plugin with Himalaya CLI v2: every shared CLI invocation now uses `mailbox` instead of `folder`, `--json` instead of `--output json`, and the `message compose` / `reply` / `forward` / `send` / `add` flow instead of the dropped `template` subcommands.
- Updated `syntax/himalaya-email-listing.vim` to recognize CLI v2 Unicode box-drawing tables (`│`, `┆`, `┌`, `└`, `╞`, `╡`, etc.) and added `HimalayaSize` column highlighting.
- Added `--seen` flag to `message read` so reading an email marks it as seen.
- Renamed user-facing option `g:himalaya_folder_picker` to `g:himalaya_mailbox_picker`.
- Renamed user-facing option `g:himalaya_folder_picker_telescope_preview` to `g:himalaya_mailbox_picker_telescope_preview`.
- Renamed user-facing commands `:HimalayaFolders` / `:HimalayaFolder` to `:HimalayaMailboxes` / `:HimalayaMailbox`.
- Renamed `<plug>(himalaya-folder-*)` mappings to `<plug>(himalaya-mailbox-*)`.
- Renamed `<plug>(himalaya-email-copy)` and `<plug>(himalaya-email-move)` to `<plug>(himalaya-email-select-mailbox-then-copy)` and `<plug>(himalaya-email-select-mailbox-then-move)` to match the underlying function names.
- Disabled CLI logs for them not to mess up with errors. [#21]

### Removed

- Removed the reply-all keybind and `<plug>(himalaya-email-reply-all)`: Himalaya CLI v2 dropped the `--all` flag from `message reply`. Use `gr` and add the extra recipients in the compose buffer.
- Removed the open-in-browser keybind and `<plug>(himalaya-email-open-browser)`: Himalaya CLI v2 dropped `message export --open`.
- Removed option `g:himalaya_custom_email_flags`: shared `flag add` / `flag remove` no longer take arbitrary flag names; v2 will reject anything outside `seen`, `answered`, `flagged`, `draft` at runtime.

### Fixed

- Fixed `envelope list` erroring on CLI v2 by routing non-empty queries to `envelope search`.
- Fixed email ID parsing to extract cell tokens between table delimiters instead of relying on digits `\d\+`, adding support for alphanumeric IDs and ignoring border rules.
- Fixed `process_draft()` sending workflow: only mark `answered` on actual replies, chain after sending succeeds, and clean up temporary draft files.
- Removed leftover debugging `echom s:stdout` from Neovim async job runner.
- Fixed changing mailbox using telescope due to script function not accessible from lua env. [#47]
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
