" Represents the current page being displayed.
let s:page = 1

" Represents the current folder being selected.
let s:folder = 'INBOX'

function! himalaya#domain#folder#current_page() abort
  return s:page
endfunction

function! himalaya#domain#folder#select_previous_page() abort
  let s:page = max([1, s:page - 1])
  call himalaya#domain#email#list()
endfunction

function! himalaya#domain#folder#select_next_page() abort
  let s:page = s:page + 1
  call himalaya#domain#email#list()
endfunction

function! himalaya#domain#folder#current() abort
  return s:folder
endfunction

function! himalaya#domain#folder#open_picker(on_select_folder) abort
  let account = himalaya#domain#account#current()
  call himalaya#request#json({
  \ 'cmd': 'folder list --account %s',
  \ 'args': [shellescape(account)],
  \ 'msg': 'Listing folders',
  \ 'on_data': {data -> s:open_picker(data, a:on_select_folder)},
  \})
endfunction

function! s:open_picker(folders, on_select_folder) abort
  if exists('g:himalaya_folder_picker')
    let picker = g:himalaya_folder_picker
  else
    if &rtp =~ 'telescope'
      let picker = 'telescope'
    elseif &rtp =~ 'fzf'
      let picker = 'fzf'
    else
      let picker = 'native'
    endif
  endif
  let select = printf('himalaya#domain#folder#pickers#%s#select', picker)
  execute printf('call %s(a:on_select_folder, a:folders)', select)
endfunction

function! himalaya#domain#folder#select() abort
  call himalaya#domain#folder#open_picker('himalaya#domain#folder#set')
endfunction

function! himalaya#domain#folder#set(folder) abort
  let s:folder = a:folder
  let s:page = 1
  call himalaya#domain#email#list()
endfunction
