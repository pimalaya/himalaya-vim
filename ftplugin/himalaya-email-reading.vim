setlocal bufhidden=wipe
setlocal buftype=nofile
setlocal filetype=mail
setlocal foldexpr=himalaya#domain#email#thread#fold(v:lnum)
setlocal foldmethod=expr
setlocal nomodifiable

call himalaya#keybinds#define([
  \['n', 'gw', 'email#write'                  ],
  \['n', 'gr', 'email#reply'                  ],
  \['n', 'gR', 'email#reply_all'              ],
  \['n', 'gf', 'email#forward'                ],
  \['n', 'ga', 'email#download_attachments'   ],
  \['n', 'gC', 'email#select_folder_then_copy'],
  \['n', 'gM', 'email#select_folder_then_move'],
  \['n', 'gD', 'email#delete'                 ],
\])
