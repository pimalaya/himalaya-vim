let s:account = ''

function! himalaya#domain#account#current() abort
  return s:account
endfunction

function! himalaya#domain#account#select(account) abort
  let s:account = a:account
endfunction
