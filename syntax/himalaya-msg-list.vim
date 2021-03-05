if exists("b:current_syntax")
  finish
endif

syntax match himalaya_separator     /|/
syntax match himalaya_table_uid     /^|.\{-}|/                    contains=himalaya_separator
syntax match himalaya_table_subject /^|.\{-}|.\{-}|/              contains=himalaya_table_uid,himalaya_separator
syntax match himalaya_table_sender  /^|.\{-}|.\{-}|.\{-}|/        contains=himalaya_table_uid,himalaya_table_subject,himalaya_separator
syntax match himalaya_table_date    /^|.\{-}|.\{-}|.\{-}|.\{-}|/  contains=himalaya_table_uid,himalaya_table_subject,himalaya_table_sender,himalaya_separator
syntax match himalaya_table_head    /.*\%1l/                      contains=himalaya_separator

highlight default link himalaya_separator     VertSplit
highlight default link himalaya_table_uid     Identifier
highlight default link himalaya_table_subject String
highlight default link himalaya_table_sender  Structure
highlight default link himalaya_table_date    Constant

highlight himalaya_table_head term=bold,underline cterm=bold,underline gui=bold,underline

let b:current_syntax = "himalaya-msg-list"
