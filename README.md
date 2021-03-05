# 📫 Himalaya.vim [WIP]

Vim plugin for [Himalaya](https://github.com/soywod/himalaya) CLI email client.

![image](https://user-images.githubusercontent.com/10437171/104848096-aee51000-58e3-11eb-8d99-bcfab5ca28ba.png)

## Table of contents

* [Motivation](#motivation)
* [Installation](#installation)
* [Usage](#usage)
  * [List mailboxes](#list-mailboxes)
  * [List emails](#list-emails)
  * [Search emails](#search-emails)
  * [Download email attachments](#download-email-attachments)
  * [Read email](#read-email)
  * [Reply email](#reply-email)
  * [Forward email](#forward-email)
* [License](https://github.com/soywod/himalaya.vim/blob/master/LICENSE)
* [Credits](#credits)

## Motivation

Bringing emails to your terminal is a pain. The mainstream TUI, (neo)mutt,
takes time to configure. The default mapping is not intuitive when coming from
the Vim environment. It is even scary to use at the beginning, since you are
dealing with sensitive data!

The aim of Himalaya is to extract the email logic into a simple CLI API that
can be used either directly for the terminal or from various interfaces. It
gives users more flexibility.

This Vim plugin is a TUI implementation for Himalaya CLI.

## Installation

First you need to install and configure the [himalaya
CLI](https://github.com/soywod/himalaya#installation). Then you can install
this plugin with your favorite plugin manager.

For eg: with [vim-plug](https://github.com/junegunn/vim-plug) add to your
`.vimrc`:

```viml
Plug "soywod/himalaya.vim"
```

Then:

```viml
:PlugInstall
```

## Usage

TODO

## Credits

- [IMAP RFC3501](https://tools.ietf.org/html/rfc3501)
- [Iris](https://github.com/soywod/iris.vim), the himalaya predecessor
- [Neomutt](https://neomutt.org/)
- [Alpine](http://alpine.x10host.com/alpine/alpine-info/)
