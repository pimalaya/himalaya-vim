function! HimalayaThreadFold(lnum)
  return getline(a:lnum)[0] == ">"
endfunction

setlocal bufhidden=wipe
setlocal buftype=nofile
setlocal cursorline
setlocal foldexpr=HimalayaThreadFold(v:lnum)
setlocal foldlevel=0
setlocal foldlevelstart=0
setlocal foldmethod=expr
setlocal nomodifiable
setlocal nowrap
setlocal startofline

let mappings = [
  \["n", "gn", "msg-new"      ],
  \["n", "gr", "msg-reply"    ],
  \["n", "gR", "msg-reply-all"],
  \["n", "gf", "msg-forward"  ],
\]

nnoremap <silent><plug>(himalaya-msg-new)       :call himalaya#msg#new()<cr>
nnoremap <silent><plug>(himalaya-msg-reply)     :call himalaya#msg#reply()<cr>
nnoremap <silent><plug>(himalaya-msg-reply-all) :call himalaya#msg#reply_all()<cr>
nnoremap <silent><plug>(himalaya-msg-forward)   :call himalaya#msg#forward()<cr>

for [mode, key, plug] in mappings
  let plug = printf("<plug>(himalaya-%s)", plug)

  if !hasmapto(plug, mode)
    execute printf("%smap <nowait><buffer> %s %s", mode, key, plug)
  endif
endfor
