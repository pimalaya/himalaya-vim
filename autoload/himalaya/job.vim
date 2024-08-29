let s:editor = has('nvim') ? 'neovim' : 'vim8'

function! himalaya#job#start(cmd, opts)
  execute 'call himalaya#job#' . s:editor . '#start(a:cmd, a:opts)'
endfunction
