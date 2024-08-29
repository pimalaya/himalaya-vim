function! himalaya#log#info(msg) abort
  echohl None
  echomsg a:msg
endfunction

function! himalaya#log#warn(msg) abort
  echohl WarningMsg
  echomsg a:msg
  echohl None
endfunction

function! himalaya#log#err(msg) abort
  echohl ErrorMsg
  echomsg a:msg
  echohl None
endfunction
