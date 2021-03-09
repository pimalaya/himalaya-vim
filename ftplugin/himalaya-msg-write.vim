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

augroup himalaya
  autocmd! * <buffer>
  autocmd  BufWriteCmd  <buffer> call himalaya#msg#draft_save()
  autocmd  BufUnload    <buffer> call himalaya#msg#draft_handle()
augroup end
