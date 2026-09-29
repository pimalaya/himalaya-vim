<div align="center">
  <img src="./logo.svg" alt="Logo" width="128" height="128" />
  <h1>📫 Himalaya Vim</h1>
  <p>Vim front-end for the email client <a href="https://github.com/pimalaya/himalaya">Himalaya CLI</a></p>
  <p>
    <a href="https://github.com/pimalaya/himalaya/releases/latest"><img alt="Release" src="https://img.shields.io/github/v/release/pimalaya/himalaya?color=success"/></a>
    <a href="https://repology.org/project/himalaya/versions"><img alt="Repology" src="https://img.shields.io/repology/repositories/himalaya?color=success"></a>
    <a href="https://matrix.to/#/#pimalaya:matrix.org"><img alt="Matrix" src="https://img.shields.io/badge/chat-%23pimalaya-blue?style=flat&logo=matrix&logoColor=white"/></a>
    <a href="https://fosstodon.org/@pimalaya"><img alt="Mastodon" src="https://img.shields.io/badge/news-%40pimalaya-blue?style=flat&logo=mastodon&logoColor=white"/></a>
    <a href="https://pimalaya.org/sponsor/"><img alt="Sponsor" src="https://img.shields.io/badge/sponsor-pink?style=flat&logo=github-sponsors&logoColor=white"/></a>
  </p>
  <p><em>We are looking for new maintainer(s), feel free to contact us! (https://github.com/pimalaya/himalaya-vim/issues/28)</em></p>
</div>

Himalaya Vim is a thin layer over the [Himalaya CLI](https://github.com/pimalaya/himalaya): accounts, identities, signatures and mailbox aliases live in the CLI configuration, and the plugin only drives the CLI from Vim.

It requires **Vim 9.1** or later and **Himalaya CLI v2**. Neovim is not supported: Neovim users are better served by the mail plugins of its own community.

## Table of contents

- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
  - [List envelopes](#list-envelopes)
  - [Read a message](#read-a-message)
  - [Write a message](#write-a-message)
- [Development](#development)
- [Sponsoring](#sponsoring)

## Installation

Install and configure the [Himalaya CLI](https://github.com/pimalaya/himalaya) first, then the plugin with your plugin manager, for example [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'https://github.com/pimalaya/himalaya-vim'
```

Or as a native package:

```sh
git clone https://github.com/pimalaya/himalaya-vim ~/.vim/pack/pimalaya/start/himalaya-vim
```

The plugin needs `filetype plugin on` and `syntax on`.

## Configuration

Every option is about Vim; everything about accounts belongs to the CLI configuration.

- `g:himalaya_executable`: path to the `himalaya` binary, `himalaya` by default.
- `g:himalaya_config_path`: CLI configuration file(s), passed as `--config`.
- `g:himalaya_account_picker`, `g:himalaya_mailbox_picker`: `native` (a popup menu) or `fzf` ([fzf.vim](https://github.com/junegunn/fzf.vim)), `fzf` by default when fzf.vim is installed.
- `g:himalaya_always_confirm`: ask before moving or deleting messages, `v:true` by default.
- `g:himalaya_complete_contact_cmd`: shell command completing contacts with `<C-x><C-u>` in a writing buffer. `%s` is replaced by the search, and each output line holds an address, then optionally a tab and a name.

## Usage

### List envelopes

`:Himalaya [account]` lists the default mailbox of the default account, or of the given one.

| Function                                           | Keybind   | Plug                                          |
|----------------------------------------------------|-----------|-----------------------------------------------|
| Change the account                                 | `gA`      | `himalaya-account-select`                     |
| Change the mailbox                                 | `gm`      | `himalaya-mailbox-select`                     |
| Previous / next page                               | `gp`/`gn` | `himalaya-mailbox-select-{previous,next}-page` |
| Search envelopes, see `himalaya envelope search -h` | `g/`      | `himalaya-email-set-list-envelopes-query`     |
| Read the message                                   | `<CR>`    | `himalaya-email-read`                         |
| Write a new message                                | `gw`      | `himalaya-email-write`                        |
| Reply to / forward the message                     | `gr`/`gf` | `himalaya-email-{reply,forward}`              |
| Edit the message as a new one (resume a draft)     | `ge`      | `himalaya-email-edit`                         |
| Download the attachments                           | `ga`      | `himalaya-email-download-attachments`         |
| Copy / move the message(s)                         | `gC`/`gM` | `himalaya-email-select-mailbox-then-{copy,move}` |
| Delete the message(s)                              | `gD`      | `himalaya-email-delete`                       |
| Add / remove flags                                 | `gFa`/`gFr` | `himalaya-email-flag-{add,remove}`          |

Copy, move, delete and flags also act on a visual selection. Every keybind maps a `<Plug>(...)` mapping, and is skipped when you already mapped that plug yourself:

```vim
nmap <Leader>r <Plug>(himalaya-email-reply)
```

### Read a message

The reading buffer shares `gw`, `gr`, `gf`, `ga`, `gC`, `gM` and `gD` with the listing, and folds quoted lines.

### Write a message

A writing buffer holds the `From`, `To`, `Cc`, `Bcc` and `Subject` headers, a blank line, then the plain text body, quote included for a reply or a forward. The signature is not shown: the CLI appends the one its configuration declares.

| Function                        | Keybind | Plug                          |
|---------------------------------|---------|-------------------------------|
| Attach a file                   | `ga`    | `himalaya-email-add-attachment` |
| Manage the attached files       | `gA`    | `himalaya-email-attachments`  |

`gA` opens the attachment list, one path per line: edit it like any buffer, then `:write` to apply it. The status line counts the attached files.

`:write` in a writing buffer asks whether to send the message, save it as a draft (in the mailbox the `drafts` alias resolves to), or cancel. `:quit!` discards it. Sending a reply flags the replied message `answered`, and sending or saving a resumed message deletes the original.

## Development

The tests run the plugin against a stub CLI, headless:

```sh
vim -Nu NONE -i NONE -es -S tests/run.vim
```

## Sponsoring

[![nlnet](https://nlnet.nl/logo/banner-160x60.png)](https://nlnet.nl/)

Special thanks to the [NLnet foundation](https://nlnet.nl/) and the [European Commission](https://www.ngi.eu/) that have been financially supporting the project for years:

- 2022 → 2023: [NGI Assure](https://nlnet.nl/project/Himalaya/)
- 2023 → 2024: [NGI Zero Entrust](https://nlnet.nl/project/Pimalaya/)
- 2024 → 2026: [NGI Zero Core](https://nlnet.nl/project/Pimalaya-PIM/)
- 2026 → 2027: [NGI Zero Commons Fund](https://nlnet.nl/project/Pimalaya-pimdir/)

This program is part of Pimalaya, free software funded entirely by grants and donations. If you find it useful, consider [sponsoring](https://pimalaya.org/sponsor/) its development:

[![GitHub](https://img.shields.io/badge/-GitHub%20Sponsors-fafbfc?logo=GitHub%20Sponsors)](https://github.com/sponsors/soywod)
[![Ko-fi](https://img.shields.io/badge/-Ko--fi-ff5e5a?logo=Ko-fi&logoColor=ffffff)](https://ko-fi.com/pimalaya)
[![Buy Me a Coffee](https://img.shields.io/badge/-Buy%20Me%20a%20Coffee-ffdd00?logo=Buy%20Me%20A%20Coffee&logoColor=000000)](https://www.buymeacoffee.com/pimalaya)
[![Liberapay](https://img.shields.io/badge/-Liberapay-f6c915?logo=Liberapay&logoColor=222222)](https://liberapay.com/pimalaya)
[![thanks.dev](https://img.shields.io/badge/-thanks.dev-000000?logo=data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQuMDk3IiBoZWlnaHQ9IjE3LjU5NyIgY2xhc3M9InctMzYgbWwtMiBsZzpteC0wIHByaW50Om14LTAgcHJpbnQ6aW52ZXJ0IiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPjxwYXRoIGQ9Ik05Ljc4MyAxNy41OTdINy4zOThjLTEuMTY4IDAtMi4wOTItLjI5Ny0yLjc3My0uODktLjY4LS41OTMtMS4wMi0xLjQ2Mi0xLjAyLTIuNjA2di0xLjM0NmMwLTEuMDE4LS4yMjctMS43NS0uNjc4LTIuMTk1LS40NTItLjQ0Ni0xLjIzMi0uNjY5LTIuMzQtLjY2OUgwVjcuNzA1aC41ODdjMS4xMDggMCAxLjg4OC0uMjIyIDIuMzQtLjY2OC40NTEtLjQ0Ni42NzctMS4xNzcuNjc3LTIuMTk1VjMuNDk2YzAtMS4xNDQuMzQtMi4wMTMgMS4wMjEtMi42MDZDNS4zMDUuMjk3IDYuMjMgMCA3LjM5OCAwaDIuMzg1djEuOTg3aC0uOTg1Yy0uMzYxIDAtLjY4OC4wMjctLjk4LjA4MmExLjcxOSAxLjcxOSAwIDAgMC0uNzM2LjMwN2MtLjIwNS4xNTYtLjM1OC4zODQtLjQ2LjY4Mi0uMTAzLjI5OC0uMTU0LjY4Mi0uMTU0IDEuMTUxVjUuMjNjMCAuODY3LS4yNDkgMS41ODYtLjc0NSAyLjE1NS0uNDk3LjU2OS0xLjE1OCAxLjAwNC0xLjk4MyAxLjMwNXYuMjE3Yy44MjUuMyAxLjQ4Ni43MzYgMS45ODMgMS4zMDUuNDk2LjU3Ljc0NSAxLjI4Ny43NDUgMi4xNTR2MS4wMjFjMCAuNDcuMDUxLjg1NC4xNTMgMS4xNTIuMTAzLjI5OC4yNTYuNTI1LjQ2MS42ODIuMTkzLjE1Ny40MzcuMjYuNzMyLjMxMi4yOTUuMDUuNjIzLjA3Ni45ODQuMDc2aC45ODVabTE0LjMxNC03LjcwNmgtLjU4OGMtMS4xMDggMC0xLjg4OC4yMjMtMi4zNC42NjktLjQ1LjQ0NS0uNjc3IDEuMTc3LS42NzcgMi4xOTVWMTQuMWMwIDEuMTQ0LS4zNCAyLjAxMy0xLjAyIDIuNjA2LS42OC41OTMtMS42MDUuODktMi43NzQuODloLTIuMzg0di0xLjk4OGguOTg0Yy4zNjIgMCAuNjg4LS4wMjcuOTgtLjA4LjI5Mi0uMDU1LjUzOC0uMTU3LjczNy0uMzA4LjIwNC0uMTU3LjM1OC0uMzg0LjQ2LS42ODIuMTAzLS4yOTguMTU0LS42ODIuMTU0LTEuMTUydi0xLjAyYzAtLjg2OC4yNDgtMS41ODYuNzQ1LTIuMTU1LjQ5Ny0uNTcgMS4xNTgtMS4wMDQgMS45ODMtMS4zMDV2LS4yMTdjLS44MjUtLjMwMS0xLjQ4Ni0uNzM2LTEuOTgzLTEuMzA1LS40OTctLjU3LS43NDUtMS4yODgtLjc0NS0yLjE1NXYtMS4wMmMwLS40Ny0uMDUxLS44NTQtLjE1NC0xLjE1Mi0uMTAyLS4yOTgtLjI1Ni0uNTI2LS40Ni0uNjgyYTEuNzE5IDEuNzE5IDAgMCAwLS43MzctLjMwNyA1LjM5NSA1LjM5NSAwIDAgMC0uOTgtLjA4MmgtLjk4NFYwaDIuMzg0YzEuMTY5IDAgMi4wOTMuMjk3IDIuNzc0Ljg5LjY4LjU5MyAxLjAyIDEuNDYyIDEuMDIgMi42MDZ2MS4zNDZjMCAxLjAxOC4yMjYgMS43NS42NzggMi4xOTUuNDUxLjQ0NiAxLjIzMS42NjggMi4zNC42NjhoLjU4N3oiIGZpbGw9IiNmZmYiLz48L3N2Zz4=)](https://thanks.dev/u/gh/soywod)
[![PayPal](https://img.shields.io/badge/-PayPal-0079c1?logo=PayPal&logoColor=ffffff)](https://www.paypal.com/paypalme/soywod)
