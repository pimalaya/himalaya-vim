vim9script

if exists('b:did_ftplugin')
  finish
endif
b:did_ftplugin = true

import autoload 'himalaya/keybinds.vim'

setlocal bufhidden=wipe
setlocal buftype=nofile
setlocal foldexpr=getline(v:lnum)=~'^>'
setlocal foldmethod=expr
setlocal nomodifiable

keybinds.Define([
  ['n', 'gw', 'email-write'],
  ['n', 'gr', 'email-reply'],
  ['n', 'gf', 'email-forward'],
  ['n', 'ga', 'email-download-attachments'],
  ['n', 'gC', 'email-select-mailbox-then-copy'],
  ['n', 'gM', 'email-select-mailbox-then-move'],
  ['n', 'gD', 'email-delete'],
])
