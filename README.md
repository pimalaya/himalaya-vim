<div align="center">
  <img src="./logo.svg" alt="Logo" width="128" height="128" />
  <h1>📫 Himalaya Vim</h1>
  <p>
    <strong>Vim front-end</strong> for the email client <a href="https://github.com/pimalaya/himalaya">Himalaya CLI</a>
  </p>
  <p>
    <a href="https://github.com/pimalaya/himalaya/releases/latest"><img alt="Release" src="https://img.shields.io/github/v/release/pimalaya/himalaya?color=success"/></a>
 <a href="https://repology.org/project/himalaya/versions"><img alt="Repology" src="https://img.shields.io/repology/repositories/himalaya?color=success"></a>
    <a href="https://matrix.to/#/#pimalaya:matrix.org"><img alt="Matrix" src="https://img.shields.io/matrix/pimalaya:matrix.org?color=success&label=chat"/></a>
  </p>
</div>

## Installation

First you need to install and configure the [Himalaya CLI](https://github.com/pimalaya/himalaya). Then you can install this plugin with your favorite plugin manager:

### Using [packer](https://github.com/wbthomason/packer.nvim)

```lua
use "https://github.com/pimalaya/himalaya-vim"
```

```vim
:PackerSync
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'https://github.com/pimalaya/himalaya-vim'
```

```vim
:PlugInstall
```

## Configuration

It is highly recommanded to have those Vim options on:

```vim
syntax on
filetype plugin on
set hidden
```

### `g:himalaya_executable`

Defines a custom path for the himalaya binary. Defaults to `himalaya`.

### `g:himalaya_config_path`

Override the default TOML configuration file.

### `g:himalaya_folder_picker`

Defines the provider used for selecting folders (default keybind: `gm`):

- `native` (default): a vim native input
- `fzf`: <https://github.com/junegunn/fzf.vim>
- `fzflua`: <https://github.com/ibhagwan/fzf-lua>
- `telescope`: <https://github.com/nvim-telescope/telescope.nvim>

If no value given, the first loaded (and available) provider will be used (telescope > fzf > native).

```vim
let g:himalaya_folder_picker = 'native' | 'fzf' | 'fzflua' | 'telescope'
```

### `g:himalaya_folder_picker_telescope_preview`

Enables folder preview when picking a folder with the `telescope.nvim` provider.

```vim
let g:himalaya_folder_picker_telescope_preview = 1
```

### `g:himalaya_complete_contact_cmd`

Defines the command to use for contact completion. When this is set, `completefunc` will be set when composing emails so that contacts can be completed with `<C-x><C-u>`.

The command must print each possible result on its own line. Each line must contain tab-separated fields; the first must be the email address, and the second, if present, must be the name. `%s` in the command will be replaced with the search query.

```vim
let g:himalaya_complete_contact_cmd = '<your completion command>'
```

### `g:himalaya_custom_email_flags`
Defines the list of additional custom flags that himalaya-vim should be aware
of. They should be specified as a list of strings:

```vim
let g:himalaya_custom_email_flags = ['custom1', 'custom2']
```


## Usage

### Folder listing

With the native picker (default):

![screenshot](https://user-images.githubusercontent.com/10437171/113631817-51eb3180-966a-11eb-8b13-cd1f1f2539ab.jpeg)

With the
[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
picker:

![screenshot](https://user-images.githubusercontent.com/10437171/113631294-86122280-9669-11eb-8074-1c43c36b65a9.jpeg)

With the [fzf.vim](https://github.com/junegunn/fzf.vim) picker:

![screenshot](https://user-images.githubusercontent.com/10437171/113631382-acd05900-9669-11eb-817d-c28fd5d9574c.jpeg)

### Envelope listing, filtering and sorting

```vim
:Himalaya
```

| Function                                               | Keybind   |
|--------------------------------------------------------|-----------|
| Change the current folder                              | `gm`      |
| Show previous page                                     | `gp`      |
| Show next page                                         | `gn`      |
| Read email under cursor                                | `<Enter>` |
| Write a new email                                      | `gw`      |
| Reply to the email under cursor                        | `gr`      |
| Reply all to the email under cursor                    | `gR`      |
| Forward the email under cursor                         | `gf`      |
| Download all attachments of email under cursor         | `ga`      |
| Copy the email under cursor                            | `gC`      |
| Move the email under cursor                            | `gM`      |
| Delete email(s) under cursor or visual selection       | `gD`      |
| Add the specified flag to the selected email(s)        | `gFa`     |
| Remove the specified flag from the selected email(s)   | `gFr`     |
| Filter and sort envelopes according to the given query | `g/`      |

Keybinds can be customized:

```vim
nmap gm   <plug>(himalaya-folder-select)
nmap gp   <plug>(himalaya-folder-select-previous-page)
nmap gn   <plug>(himalaya-folder-select-next-page)
nmap <cr> <plug>(himalaya-email-read)
nmap gw   <plug>(himalaya-email-write)
nmap gr   <plug>(himalaya-email-reply)
nmap gR   <plug>(himalaya-email-reply-all)
nmap gf   <plug>(himalaya-email-forward)
nmap ga   <plug>(himalaya-email-download-attachments)
nmap gC   <plug>(himalaya-email-copy)
nmap gM   <plug>(himalaya-email-move)
nmap gD   <plug>(himalaya-email-delete)
nmap gFa  <plug>(himalaya-email-flag-add)
nmap gFr  <plug>(himalaya-email-flag-remove)
nmap g/   <plug>(himalaya-set-list-envelopes-query)
```

*Note: see the [documentation](https://pimalaya.org/himalaya/cli/latest/usage/advanced/envelope/list.html#query) for more detailed information about the query API.*

### Message reading

| Function                       | Keybind |
|--------------------------------|---------|
| Write a new email              | `gw`    |
| Reply to the email             | `gr`    |
| Reply all to the email         | `gR`    |
| Forward the email              | `gf`    |
| Download all email attachments | `ga`    |
| Copy the email                 | `gC`    |
| Move the email                 | `gM`    |
| Delete the email               | `gD`    |

Keybinds can be customized:

```vim
nmap gw <plug>(himalaya-email-write)
nmap gr <plug>(himalaya-email-reply)
nmap gR <plug>(himalaya-email-reply-all)
nmap gf <plug>(himalaya-email-forward)
nmap ga <plug>(himalaya-email-download-attachments)
nmap gC <plug>(himalaya-email-copy)
nmap gM <plug>(himalaya-email-move)
nmap gD <plug>(himalaya-email-delete)
```

### Message writing

| Function       | Keybind |
|----------------|---------|
| Add attachment | `ga`    |

Keybinds can be customized:

```vim
nmap ga <plug>(himalaya-email-add-attachment)
```

When you exit this special buffer, you will be prompted 4 choices:

- `send`: sends the email
- `draft`: saves the email locally
- `quit`: quits the buffer without saving
- `cancel`: goes back to the email edition

## Development

The development environment is managed by [Nix](https://nixos.org/download.html). Running `nix-shell` will spawn a shell with everything you need to get started with this plugin:

```sh
# starts a nix shell
$ nix-shell

# starts Vim and the :Himalaya command
$ vim +Himalaya

# starts Neovim and the :Himalaya command
$ nvim +Himalaya
```

## Sponsoring

[![nlnet](https://nlnet.nl/logo/banner-160x60.png)](https://nlnet.nl/project/Himalaya/index.html)

Special thanks to the [NLnet foundation](https://nlnet.nl/project/Himalaya/index.html) and the [European Commission](https://www.ngi.eu/) that helped the project to receive financial support from:

- [NGI Assure](https://nlnet.nl/assure/) in 2022
- [NGI Zero Entrust](https://nlnet.nl/entrust/) in 2023

If you appreciate the project, feel free to donate using one of the following providers:

[![GitHub](https://img.shields.io/badge/-GitHub%20Sponsors-fafbfc?logo=GitHub%20Sponsors)](https://github.com/sponsors/soywod)
[![Ko-fi](https://img.shields.io/badge/-Ko--fi-ff5e5a?logo=Ko-fi&logoColor=ffffff)](https://ko-fi.com/soywod)
[![Buy Me a Coffee](https://img.shields.io/badge/-Buy%20Me%20a%20Coffee-ffdd00?logo=Buy%20Me%20A%20Coffee&logoColor=000000)](https://www.buymeacoffee.com/soywod)
[![Liberapay](https://img.shields.io/badge/-Liberapay-f6c915?logo=Liberapay&logoColor=222222)](https://liberapay.com/soywod)
[![thanks.dev](https://img.shields.io/badge/-thanks.dev-000000?logo=data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQuMDk3IiBoZWlnaHQ9IjE3LjU5NyIgY2xhc3M9InctMzYgbWwtMiBsZzpteC0wIHByaW50Om14LTAgcHJpbnQ6aW52ZXJ0IiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPjxwYXRoIGQ9Ik05Ljc4MyAxNy41OTdINy4zOThjLTEuMTY4IDAtMi4wOTItLjI5Ny0yLjc3My0uODktLjY4LS41OTMtMS4wMi0xLjQ2Mi0xLjAyLTIuNjA2di0xLjM0NmMwLTEuMDE4LS4yMjctMS43NS0uNjc4LTIuMTk1LS40NTItLjQ0Ni0xLjIzMi0uNjY5LTIuMzQtLjY2OUgwVjcuNzA1aC41ODdjMS4xMDggMCAxLjg4OC0uMjIyIDIuMzQtLjY2OC40NTEtLjQ0Ni42NzctMS4xNzcuNjc3LTIuMTk1VjMuNDk2YzAtMS4xNDQuMzQtMi4wMTMgMS4wMjEtMi42MDZDNS4zMDUuMjk3IDYuMjMgMCA3LjM5OCAwaDIuMzg1djEuOTg3aC0uOTg1Yy0uMzYxIDAtLjY4OC4wMjctLjk4LjA4MmExLjcxOSAxLjcxOSAwIDAgMC0uNzM2LjMwN2MtLjIwNS4xNTYtLjM1OC4zODQtLjQ2LjY4Mi0uMTAzLjI5OC0uMTU0LjY4Mi0uMTU0IDEuMTUxVjUuMjNjMCAuODY3LS4yNDkgMS41ODYtLjc0NSAyLjE1NS0uNDk3LjU2OS0xLjE1OCAxLjAwNC0xLjk4MyAxLjMwNXYuMjE3Yy44MjUuMyAxLjQ4Ni43MzYgMS45ODMgMS4zMDUuNDk2LjU3Ljc0NSAxLjI4Ny43NDUgMi4xNTR2MS4wMjFjMCAuNDcuMDUxLjg1NC4xNTMgMS4xNTIuMTAzLjI5OC4yNTYuNTI1LjQ2MS42ODIuMTkzLjE1Ny40MzcuMjYuNzMyLjMxMi4yOTUuMDUuNjIzLjA3Ni45ODQuMDc2aC45ODVabTE0LjMxNC03LjcwNmgtLjU4OGMtMS4xMDggMC0xLjg4OC4yMjMtMi4zNC42NjktLjQ1LjQ0NS0uNjc3IDEuMTc3LS42NzcgMi4xOTVWMTQuMWMwIDEuMTQ0LS4zNCAyLjAxMy0xLjAyIDIuNjA2LS42OC41OTMtMS42MDUuODktMi43NzQuODloLTIuMzg0di0xLjk4OGguOTg0Yy4zNjIgMCAuNjg4LS4wMjcuOTgtLjA4LjI5Mi0uMDU1LjUzOC0uMTU3LjczNy0uMzA4LjIwNC0uMTU3LjM1OC0uMzg0LjQ2LS42ODIuMTAzLS4yOTguMTU0LS42ODIuMTU0LTEuMTUydi0xLjAyYzAtLjg2OC4yNDgtMS41ODYuNzQ1LTIuMTU1LjQ5Ny0uNTcgMS4xNTgtMS4wMDQgMS45ODMtMS4zMDV2LS4yMTdjLS44MjUtLjMwMS0xLjQ4Ni0uNzM2LTEuOTgzLTEuMzA1LS40OTctLjU3LS43NDUtMS4yODgtLjc0NS0yLjE1NXYtMS4wMmMwLS40Ny0uMDUxLS44NTQtLjE1NC0xLjE1Mi0uMTAyLS4yOTgtLjI1Ni0uNTI2LS40Ni0uNjgyYTEuNzE5IDEuNzE5IDAgMCAwLS43MzctLjMwNyA1LjM5NSA1LjM5NSAwIDAgMC0uOTgtLjA4MmgtLjk4NFYwaDIuMzg0YzEuMTY5IDAgMi4wOTMuMjk3IDIuNzc0Ljg5LjY4LjU5MyAxLjAyIDEuNDYyIDEuMDIgMi42MDZ2MS4zNDZjMCAxLjAxOC4yMjYgMS43NS42NzggMi4xOTUuNDUxLjQ0NiAxLjIzMS42NjggMi4zNC42NjhoLjU4N3oiIGZpbGw9IiNmZmYiLz48L3N2Zz4=)](https://thanks.dev/soywod)
[![PayPal](https://img.shields.io/badge/-PayPal-0079c1?logo=PayPal&logoColor=ffffff)](https://www.paypal.com/paypalme/soywod)
