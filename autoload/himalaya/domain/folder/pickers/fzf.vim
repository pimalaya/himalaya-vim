" Represents the folder picker based on [fzf] and [fzf.vim]. Both need
" to be installed in order to use this picker.
"
" [fzf]: https://github.com/junegunn/fzf
" [fzf.vim]: https://github.com/junegunn/fzf.vim
function! himalaya#domain#folder#pickers#fzf#select(callback, folders) abort
  call fzf#run({
  \ 'source': map(a:folders, 'v:val.name'),
  \ 'sink': function(a:callback),
  \ 'down': '25%',
  \})
endfunction
