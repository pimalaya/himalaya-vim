if exists("b:current_syntax")
  finish
endif

syntax match himalaya_separator        /|/
syntax match himalaya_table_id         /^|.\{-}|/                            contains=himalaya_separator
syntax match himalaya_table_desc       /^|.\{-}|.\{-}|/                      contains=himalaya_table_id,himalaya_separator
syntax match himalaya_table_project    /^|.\{-}|.\{-}|.\{-}|/                contains=himalaya_table_id,himalaya_table_desc,himalaya_separator
syntax match himalaya_table_active     /^|.\{-}|.\{-}|.\{-}|.\{-}|/          contains=himalaya_table_id,himalaya_table_desc,himalaya_table_project,himalaya_separator
syntax match himalaya_table_due        /^|.\{-}|.\{-}|.\{-}|.\{-}|.\{-}|/    contains=himalaya_table_id,himalaya_table_desc,himalaya_table_project,himalaya_table_active,himalaya_separator
syntax match himalaya_table_due_alert  /^|.\{-}|.\{-}|.\{-}|.\{-}|.*ago.*|/  contains=himalaya_table_id,himalaya_table_desc,himalaya_table_project,himalaya_table_active,himalaya_separator
syntax match himalaya_table_head       /.*\%1l/                              contains=himalaya_separator

highlight default link himalaya_separator        VertSplit
highlight default link himalaya_table_id         Identifier
highlight default link himalaya_table_desc       Comment
highlight default link himalaya_table_project    Tag
highlight default link himalaya_table_active     String
highlight default link himalaya_table_due        Structure
highlight default link himalaya_table_due_alert  Error

highlight himalaya_table_head term=bold,underline cterm=bold,underline gui=bold,underline

let b:current_syntax = "himalaya-list"
