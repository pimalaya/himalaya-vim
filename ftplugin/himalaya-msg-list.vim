setlocal buftype=nofile
setlocal cursorline
setlocal nomodifiable
setlocal nowrap
setlocal startofline

nnoremap <buffer><silent>q     :bwipeout<cr>
nnoremap <buffer><silent><cr>  :bwipeout<cr>
nnoremap <buffer><silent><esc> :bwipeout<cr>

call himalaya#shared#define_bindings([
  \["n", "gm"  , "mbox#input"    ],
  \["n", "gp"  , "mbox#prev_page"],
  \["n", "gn"  , "mbox#next_page"],
  \["n", "<cr>", "msg#read"      ],
  \["n", "gw"  , "msg#write"     ],
  \["n", "gr"  , "msg#reply"     ],
  \["n", "gR"  , "msg#reply_all" ],
  \["n", "gf"  , "msg#forward"   ],
\])
