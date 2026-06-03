" Represents the mailbox picker based on [fzf] and [fzf.vim]. Both need
" to be installed in order to use this picker.
"
" [fzf]: https://github.com/junegunn/fzf
" [fzf.vim]: https://github.com/junegunn/fzf.vim
function! himalaya#domain#mailbox#pickers#fzf#select(callback, mailboxes) abort
  call fzf#run({
  \ 'source': map(a:mailboxes, 'v:val.name'),
  \ 'sink': function(a:callback),
  \ 'down': '25%',
  \})
endfunction
