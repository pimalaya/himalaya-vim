" Represents the mailbox picker based on [telescope.nvim]. The plugin
" needs to be installed in order to use this picker. Only works on
" Neovim.
"
" [telescope.nvim]: https://github.com/nvim-telescope/telescope.nvim
function! himalaya#domain#mailbox#pickers#telescope#select(callback, mailboxes) abort
  call luaeval('require("himalaya.mailbox.pickers.telescope").select')(a:callback, a:mailboxes)
endfunction
