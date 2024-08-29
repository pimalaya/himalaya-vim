setlocal filetype=mail
setlocal foldexpr=himalaya#domain#email#thread#fold(v:lnum)
setlocal foldmethod=expr
setlocal startofline

if exists('g:himalaya_complete_contact_cmd')
  setlocal completefunc=himalaya#domain#email#complete_contact
endif

call himalaya#keybinds#define([
  \['n', 'ga', 'email#add_attachment'],
\])

augroup himalaya_write
  autocmd! * <buffer>
  autocmd  BufWriteCmd <buffer> call himalaya#domain#email#save_draft()
  autocmd  BufLeave    <buffer> call himalaya#domain#email#process_draft()
augroup end
