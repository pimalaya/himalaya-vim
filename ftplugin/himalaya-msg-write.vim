function! HimalayaThreadFold(lnum)
  return getline(a:lnum)[0] == ">"
endfunction

setlocal cursorline
setlocal foldexpr=HimalayaThreadFold(v:lnum)
setlocal foldlevel=0
setlocal foldlevelstart=0
setlocal foldmethod=expr
setlocal nowrap
setlocal startofline

let mappings = [
  \["n", "gs", "msg-send"],
\]

nnoremap <silent><plug>(himalaya-msg-send) :call himalaya#msg#send()<cr>

for [mode, key, plug] in mappings
  let plug = printf("<plug>(himalaya-%s)", plug)

  if !hasmapto(plug, mode)
    execute printf("%smap <nowait><buffer> %s %s", mode, key, plug)
  endif
endfor
