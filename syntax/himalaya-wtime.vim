if exists("b:current_syntax")
  finish
endif

syntax match himalaya_wtime_separator  /[|-]/
syntax match himalaya_wtime_time       /\(|.*|\)\@<=.*|/ contains=himalaya_wtime_separator
syntax match himalaya_wtime_date       /|.\{-}|/         contains=himalaya_wtime_separator
syntax match himalaya_wtime_total      /|TOTAL.*|$/      contains=himalaya_wtime_separator,himalaya_wtime_time
syntax match himalaya_wtime_head       /.*\%1l/          contains=himalaya_wtime_separator

highlight default link himalaya_wtime_separator  VertSplit
highlight default link himalaya_wtime_date       Comment
highlight default link himalaya_wtime_time       Structure
highlight default link himalaya_wtime_total      Tag

highlight himalaya_wtime_head term=bold,underline cterm=bold,underline gui=bold,underline

let b:current_syntax = "himalaya-wtime"
