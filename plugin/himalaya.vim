vim9script

if exists('g:himalaya_loaded')
  finish
endif
g:himalaya_loaded = true

if v:version < 901
  echoerr 'himalaya-vim requires Vim 9.1 or later'
  finish
endif

import autoload 'himalaya/account.vim'
import autoload 'himalaya/compose.vim'
import autoload 'himalaya/envelope.vim'
import autoload 'himalaya/mailbox.vim'
import autoload 'himalaya/message.vim'

command! -nargs=? Himalaya envelope.Open(<q-args>)
command! HimalayaAccounts account.Select()
command! -nargs=1 HimalayaAccount account.Set(<q-args>)
command! HimalayaMailboxes mailbox.Select()
command! -nargs=1 HimalayaMailbox mailbox.Set(<q-args>)
command! HimalayaFolders mailbox.Select()
command! -nargs=1 HimalayaFolder mailbox.Set(<q-args>)
command! HimalayaNextPage mailbox.NextPage()
command! HimalayaPreviousPage mailbox.PreviousPage()
command! HimalayaWrite compose.New()
command! HimalayaReply compose.Reply()
command! HimalayaForward compose.Forward()
command! HimalayaEdit compose.Edit()
command! -range HimalayaCopy message.SelectMailboxThenCopy(<line1>, <line2>)
command! -range HimalayaMove message.SelectMailboxThenMove(<line1>, <line2>)
command! -range HimalayaDelete message.Delete(<line1>, <line2>)
command! -range HimalayaFlagAdd message.FlagAdd(<line1>, <line2>)
command! -range HimalayaFlagRemove message.FlagRemove(<line1>, <line2>)
command! HimalayaAttachments message.DownloadAttachments()

nnoremap <Plug>(himalaya-account-select) <ScriptCmd>account.Select()<CR>
nnoremap <Plug>(himalaya-mailbox-select) <ScriptCmd>mailbox.Select()<CR>
nnoremap <Plug>(himalaya-mailbox-select-previous-page) <ScriptCmd>mailbox.PreviousPage()<CR>
nnoremap <Plug>(himalaya-mailbox-select-next-page) <ScriptCmd>mailbox.NextPage()<CR>
nnoremap <Plug>(himalaya-email-set-list-envelopes-query) <ScriptCmd>envelope.SetQuery()<CR>
nnoremap <Plug>(himalaya-email-read) <ScriptCmd>message.Read()<CR>
nnoremap <Plug>(himalaya-email-write) <ScriptCmd>compose.New()<CR>
nnoremap <Plug>(himalaya-email-reply) <ScriptCmd>compose.Reply()<CR>
nnoremap <Plug>(himalaya-email-forward) <ScriptCmd>compose.Forward()<CR>
nnoremap <Plug>(himalaya-email-edit) <ScriptCmd>compose.Edit()<CR>
nnoremap <Plug>(himalaya-email-download-attachments) <ScriptCmd>message.DownloadAttachments()<CR>
nnoremap <Plug>(himalaya-email-add-attachment) <ScriptCmd>compose.AddAttachment()<CR>
nnoremap <Plug>(himalaya-email-attachments) <ScriptCmd>compose.OpenAttachments()<CR>

for [name, fn] in [
    ['select-mailbox-then-copy', 'SelectMailboxThenCopy'],
    ['select-mailbox-then-move', 'SelectMailboxThenMove'],
    ['delete', 'Delete'],
    ['flag-add', 'FlagAdd'],
    ['flag-remove', 'FlagRemove'],
  ]
  execute $'nnoremap <Plug>(himalaya-email-{name}) <ScriptCmd>message.{fn}(line("."), line("."))<CR>'
  execute $'xnoremap <Plug>(himalaya-email-{name}) <Esc><ScriptCmd>message.{fn}(line("''<"), line("''>"))<CR>'
endfor
