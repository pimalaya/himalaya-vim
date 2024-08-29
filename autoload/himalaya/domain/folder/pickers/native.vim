" Represents the folder picker based the standard vim function
" input. See `help input`.
function! himalaya#domain#folder#pickers#native#select(callback, folders) abort
  let folders = map(copy(a:folders), 'printf("%s (%d)", v:val.name, v:key)')
  
  let folder_index = input(join(folders, ', ') . ': ')
  if folder_index == ''
    throw 'Action aborted!'
  endif
  
  redraw | echo
  call function(a:callback)(a:folders[folder_index].name)
endfunction
