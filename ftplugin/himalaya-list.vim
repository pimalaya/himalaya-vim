setlocal buftype=acwrite
setlocal cursorline
setlocal nowrap
setlocal startofline

let mappings = [
  \['n', 'gd',      'list-done'     ],
  \['n', 'gD',      'list-deleted'  ],
  \['n', '<cr>',    'toggle'        ],
  \['n', 'K',       'show'          ],
  \['n', 'gc',      'context'       ],
  \['n', 'gw',      'worktime'      ],
  \['n', '<c-n>',   'next-cell'     ],
  \['n', '<c-p>',   'prev-cell'     ],
  \['n', 'dic',     'delete-in-cell'],
  \['n', 'cic',     'change-in-cell'],
  \['n', 'vic',     'visual-in-cell'],
\]

nnoremap <silent> <plug>(himalaya-list-done)     :call himalaya#ui#list_done()    <cr>
nnoremap <silent> <plug>(himalaya-list-deleted)  :call himalaya#ui#list_deleted() <cr>
nnoremap <silent> <plug>(himalaya-toggle)        :call himalaya#ui#toggle()       <cr>
nnoremap <silent> <plug>(himalaya-show)          :call himalaya#ui#show()         <cr>
nnoremap <silent> <plug>(himalaya-context)       :call himalaya#ui#context()      <cr>
nnoremap <silent> <plug>(himalaya-worktime)      :call himalaya#ui#worktime()     <cr>

nnoremap <silent> <plug>(himalaya-next-cell)  :call himalaya#ui#select_next_cell()<cr>
nnoremap <silent> <plug>(himalaya-prev-cell)  :call himalaya#ui#select_prev_cell()<cr>

nnoremap <silent> <plug>(himalaya-delete-in-cell) :call himalaya#ui#delete_in_cell()<cr>
nnoremap <silent> <plug>(himalaya-change-in-cell) :call himalaya#ui#change_in_cell()<cr>
nnoremap <silent> <plug>(himalaya-visual-in-cell) :call himalaya#ui#visual_in_cell()<cr>

for [mode, key, plug] in mappings
  let plug = printf('<plug>(himalaya-%s)', plug)

  if !hasmapto(plug, mode)
    execute printf('%smap <nowait> <buffer> %s %s', mode, key, plug)
  endif
endfor

augroup himalaya-list
  autocmd! * <buffer>
  autocmd  BufWriteCmd <buffer> call himalaya#ui#parse_buffer()
augroup end
