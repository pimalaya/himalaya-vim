# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Added option `g:himalaya_config_path` to customize the TOML configuration file.

### Changed

- Adjusted code for Himalaya CLI `v1.0.0-beta`.

### Fixed

- Fixed changing folder using telescope due to script function not accessible from lua env [#47].
- Fixed copy, move and delete not working when using multiple ids [#147].
- Fixed too long JSON string not being processed [#98].

## [0.7.1]

### Added

- Replaced system calls by async jobs [github#230].
- Set email listing page size to windows height [github#46].

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

[Unreleased]: https://git.sr.ht/~soywod/himalaya-vim/tree/develop
[0.7.1]: https://git.sr.ht/~soywod/himalaya-vim/refs/v0.7.1

[#47]: https://todo.sr.ht/~soywod/pimalaya/47
[#98]: https://todo.sr.ht/~soywod/pimalaya/98
[#147]: https://todo.sr.ht/~soywod/pimalaya/147

[github#230]: https://github.com/soywod/himalaya/issues/230
[github#46]: https://github.com/soywod/himalaya/issues/46
