let s:account = ''

function! himalaya#domain#account#current() abort
  return s:account
endfunction

function! himalaya#domain#account#open_picker(on_select_account) abort
  call himalaya#request#json({
  \ 'cmd': 'account list',
  \ 'args': [],
  \ 'msg': 'Listing accounts',
  \ 'on_data': {data -> s:open_picker(data.accounts, a:on_select_account)},
  \})
endfunction

function! s:open_picker(accounts, on_select_account) abort
  if exists('g:himalaya_account_picker')
    let picker = g:himalaya_account_picker
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
  let select = printf('himalaya#domain#account#pickers#%s#select', picker)
  execute printf('call %s(a:on_select_account, a:accounts)', select)
endfunction

function! himalaya#domain#account#select() abort
  call himalaya#domain#account#open_picker('himalaya#domain#account#set')
endfunction

function! himalaya#domain#account#set(account) abort
  let s:account = a:account
  call himalaya#domain#mailbox#set('INBOX')
endfunction
