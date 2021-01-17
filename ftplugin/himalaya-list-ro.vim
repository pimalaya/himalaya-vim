setlocal bufhidden=wipe
setlocal buftype=nofile
setlocal cursorline
setlocal nomodifiable
setlocal nowrap
setlocal startofline

nnoremap <buffer> <silent> q     :bwipeout<cr>
nnoremap <buffer> <silent> <cr>  :bwipeout<cr>
nnoremap <buffer> <silent> <esc> :bwipeout<cr>

let mappings = [
  \['n', 'K',       'show'          ],
  \['n', '<c-n>',   'next-cell'     ],
  \['n', '<c-p>',   'prev-cell'     ],
  \['n', 'vic',     'visual-in-cell'],
\]

nnoremap <silent> <plug>(himalaya-show)            :call himalaya#ui#show()             <cr>
nnoremap <silent> <plug>(himalaya-next-cell)       :call himalaya#ui#select_next_cell() <cr>
nnoremap <silent> <plug>(himalaya-prev-cell)       :call himalaya#ui#select_prev_cell() <cr>
nnoremap <silent> <plug>(himalaya-visual-in-cell)  :call himalaya#ui#visual_in_cell()   <cr>

for [mode, key, plug] in mappings
  let plug = printf('<plug>(himalaya-%s)', plug)

  if !hasmapto(plug, mode)
    execute printf('%smap <nowait> <buffer> %s %s', mode, key, plug)
  endif
endfor
