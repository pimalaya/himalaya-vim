vim9script

if exists('b:did_ftplugin')
  finish
endif
b:did_ftplugin = true

import autoload 'himalaya/compose.vim'
import autoload 'himalaya/keybinds.vim'

setlocal foldexpr=getline(v:lnum)=~'^>'
setlocal foldmethod=expr
setlocal statusline=%f\ %h%m%r%=%{himalaya#compose#Status()}\ %l,%c

if exists('g:himalaya_complete_contact_cmd')
  setlocal completefunc=himalaya#compose#CompleteContact
endif

keybinds.Define([
  ['n', 'ga', 'email-add-attachment'],
  ['n', 'gA', 'email-attachments'],
])

augroup himalaya_writing
  autocmd! * <buffer>
  autocmd BufWriteCmd <buffer> compose.Submit()
  autocmd BufWipeout <buffer> compose.Cleanup(str2nr(expand('<abuf>')))
augroup END
