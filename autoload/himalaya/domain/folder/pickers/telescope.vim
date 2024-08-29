" Represents the folder picker based on [telescope.nvim]. The plugin
" needs to be installed in order to use this picker. Only works on
" Neovim.
"
" [telescope.nvim]: https://github.com/nvim-telescope/telescope.nvim
function! himalaya#domain#folder#pickers#telescope#select(callback, folders) abort
  call luaeval('require("himalaya.folder.pickers.telescope").select')(a:callback, a:folders)
endfunction
