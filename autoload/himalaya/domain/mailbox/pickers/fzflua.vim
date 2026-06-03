" Represents the mailbox picker based on [fzf-lua]. The plugin
" needs to be installed in order to use this picker. Only works on
" Neovim.
"
" [fzf-lua]: https://github.com/ibhagwan/fzf-lua
function! himalaya#domain#mailbox#pickers#fzflua#select(callback, mailboxes) abort
  call luaeval('require("himalaya.mailbox.pickers.fzflua").select')(a:callback, a:mailboxes)
endfunction
