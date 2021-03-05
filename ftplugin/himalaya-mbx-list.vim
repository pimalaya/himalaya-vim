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
  \["n", "<cr>", "mbx-select"],
\]

nnoremap <silent> <plug>(himalaya-mbx-select) :call himalaya#mbx#select() <cr>

for [mode, key, plug] in mappings
  let plug = printf("<plug>(himalaya-%s)", plug)

  if !hasmapto(plug, mode)
    execute printf("%smap <nowait> <buffer> %s %s", mode, key, plug)
  endif
endfor
