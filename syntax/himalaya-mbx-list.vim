if exists("b:current_syntax")
  finish
endif

syntax match himalaya_separator         /|/
syntax match himalaya_table_delim       /^|.\{-}|/              contains=himalaya_separator
syntax match himalaya_table_name        /^|.\{-}|.\{-}|/        contains=himalaya_table_delim,himalaya_separator
syntax match himalaya_table_attributes  /^|.\{-}|.\{-}|.\{-}|/  contains=himalaya_table_delim,himalaya_table_name,himalaya_separator
syntax match himalaya_table_head        /.*\%1l/                contains=himalaya_separator

highlight default link himalaya_separator         VertSplit
highlight default link himalaya_table_delim       Structure
highlight default link himalaya_table_name        String
highlight default link himalaya_table_attributes  Special

highlight himalaya_table_head term=bold,underline cterm=bold,underline gui=bold,underline

let b:current_syntax = "himalaya-mbx-list"
