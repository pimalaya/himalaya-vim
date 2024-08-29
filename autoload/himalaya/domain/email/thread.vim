function! himalaya#domain#email#thread#fold(lnum) abort
  return getline(a:lnum)[0] == '>'
endfunction
