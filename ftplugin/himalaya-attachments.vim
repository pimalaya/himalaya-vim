vim9script

if exists('b:did_ftplugin')
  finish
endif
b:did_ftplugin = true

import autoload 'himalaya/compose.vim'
import autoload 'himalaya/keybinds.vim'

setlocal buftype=acwrite
setlocal bufhidden=wipe
setlocal nowrap

keybinds.Define([
  ['n', 'ga', 'email-add-attachment'],
])

augroup himalaya_attachments
  autocmd! * <buffer>
  autocmd BufWriteCmd <buffer> compose.WriteAttachments()
augroup END
