setlocal bufhidden=wipe
setlocal buftype=nofile
setlocal cursorline
setlocal nomodifiable
setlocal nowrap
setlocal startofline

nnoremap <buffer><silent>q     :bwipeout<cr>
nnoremap <buffer><silent><cr>  :bwipeout<cr>
nnoremap <buffer><silent><esc> :bwipeout<cr>

call himalaya#shared#define_bindings([
  \["n", "gm"  , "mbox-input"],
  \["n", "<cr>", "msg-read"  ],
  \["n", "gw"  , "msg-write" ],
  \["n", "gp"  , "msg-prev"  ],
  \["n", "gn"  , "msg-next"  ],
\])
