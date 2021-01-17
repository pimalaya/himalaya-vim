if exists("b:current_syntax")
  finish
endif

syntax match himalaya_info_separator /|/
syntax match himalaya_info_id        /\(|.*\)\@<=|.*|\%2l/ contains=himalaya_info_separator
syntax match himalaya_info_desc      /\(|.*\)\@<=|.*|\%3l/ contains=himalaya_info_separator
syntax match himalaya_info_project   /\(|.*\)\@<=|.*|\%4l/ contains=himalaya_info_separator
syntax match himalaya_info_active    /\(|.*\)\@<=|.*|\%5l/ contains=himalaya_info_separator
syntax match himalaya_info_due       /\(|.*\)\@<=|.*|\%6l/ contains=himalaya_info_separator
syntax match himalaya_info_wtime     /\(|.*\)\@<=|.*|\%7l/ contains=himalaya_info_separator
syntax match himalaya_info_head      /.*\%1l/              contains=himalaya_info_separator

highlight default link himalaya_info_separator VertSplit
highlight default link himalaya_info_key       Comment
highlight default link himalaya_info_id        Identifier
highlight default link himalaya_info_desc      Comment
highlight default link himalaya_info_project   Tag
highlight default link himalaya_info_active    String
highlight default link himalaya_info_due       Structure
highlight default link himalaya_info_wtime     Structure

highlight himalaya_info_head term=bold,underline cterm=bold,underline gui=bold,underline

let b:current_syntax = "himalaya-show"
