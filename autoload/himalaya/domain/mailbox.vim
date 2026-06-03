" Represents the current page being displayed.
let s:page = 1

" Represents the current mailbox being selected.
let s:mailbox = 'INBOX'

function! himalaya#domain#mailbox#current_page() abort
  return s:page
endfunction

function! himalaya#domain#mailbox#select_previous_page() abort
  let s:page = max([1, s:page - 1])
  call himalaya#domain#email#list()
endfunction

function! himalaya#domain#mailbox#select_next_page() abort
  let s:page = s:page + 1
  call himalaya#domain#email#list()
endfunction

function! himalaya#domain#mailbox#current() abort
  return s:mailbox
endfunction

function! himalaya#domain#mailbox#open_picker(on_select_mailbox) abort
  let account = himalaya#domain#account#current()
  call himalaya#request#json({
  \ 'cmd': 'mailbox list --account %s',
  \ 'args': [shellescape(account)],
  \ 'msg': 'Listing mailboxes',
  \ 'on_data': {data -> s:open_picker(data.mailboxes, a:on_select_mailbox)},
  \})
endfunction

function! s:open_picker(mailboxes, on_select_mailbox) abort
  if exists('g:himalaya_mailbox_picker')
    let picker = g:himalaya_mailbox_picker
  else
    if &rtp =~ 'telescope'
      let picker = 'telescope'
    elseif &rtp =~ 'fzflua'
      let picker = 'fzflua'
    elseif &rtp =~ 'fzf'
      let picker = 'fzf'
    else
      let picker = 'native'
    endif
  endif
  let select = printf('himalaya#domain#mailbox#pickers#%s#select', picker)
  execute printf('call %s(a:on_select_mailbox, a:mailboxes)', select)
endfunction

function! himalaya#domain#mailbox#select() abort
  call himalaya#domain#mailbox#open_picker('himalaya#domain#mailbox#set')
endfunction

function! himalaya#domain#mailbox#set(mailbox) abort
  let s:mailbox = a:mailbox
  let s:page = 1
  call himalaya#domain#email#list()
endfunction
