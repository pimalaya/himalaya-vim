vim9script

if exists('b:did_ftplugin')
  finish
endif
b:did_ftplugin = true

import autoload 'himalaya/keybinds.vim'

setlocal buftype=nofile
setlocal cursorline
setlocal nomodifiable
setlocal nowrap

keybinds.Define([
  ['n', 'gA', 'account-select'],
  ['n', 'gm', 'mailbox-select'],
  ['n', 'gp', 'mailbox-select-previous-page'],
  ['n', 'gn', 'mailbox-select-next-page'],
  ['n', 'g/', 'email-set-list-envelopes-query'],
  ['n', '<CR>', 'email-read'],
  ['n', 'gw', 'email-write'],
  ['n', 'gr', 'email-reply'],
  ['n', 'gf', 'email-forward'],
  ['n', 'ge', 'email-edit'],
  ['n', 'ga', 'email-download-attachments'],
  ['n', 'gC', 'email-select-mailbox-then-copy'],
  ['x', 'gC', 'email-select-mailbox-then-copy'],
  ['n', 'gM', 'email-select-mailbox-then-move'],
  ['x', 'gM', 'email-select-mailbox-then-move'],
  ['n', 'gD', 'email-delete'],
  ['x', 'gD', 'email-delete'],
  ['n', 'gFa', 'email-flag-add'],
  ['x', 'gFa', 'email-flag-add'],
  ['n', 'gFr', 'email-flag-remove'],
  ['x', 'gFr', 'email-flag-remove'],
])
