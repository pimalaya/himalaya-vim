setlocal buftype=nofile
setlocal cursorline
setlocal nomodifiable
setlocal nowrap

call himalaya#keybinds#define([
  \['n', 'gA'  , 'account#select'                  ],
  \['n', 'gm'  , 'mailbox#select'                  ],
  \['n', 'gp'  , 'mailbox#select_previous_page'    ],
  \['n', 'gn'  , 'mailbox#select_next_page'        ],
  \['n', '<cr>', 'email#read'                      ],
  \['n', 'gw'  , 'email#write'                     ],
  \['n', 'gr'  , 'email#reply'                     ],
  \['n', 'gf'  , 'email#forward'                   ],
  \['n', 'ga'  , 'email#download_attachments'      ],
  \['n', 'gC'  , 'email#select_mailbox_then_copy'  ],
  \['n', 'gM'  , 'email#select_mailbox_then_move'  ],
  \['n', 'gD'  , 'email#delete'                    ],
  \['v', 'gD'  , 'email#delete'                    ],
  \['n', 'gFa' , 'email#flag_add'                  ],
  \['v', 'gFa' , 'email#flag_add'                  ],
  \['n', 'gFr' , 'email#flag_remove'               ],
  \['v', 'gFr' , 'email#flag_remove'               ],
  \['n', 'g/'  , 'email#set_list_envelopes_query'  ],
\])
