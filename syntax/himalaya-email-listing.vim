if exists('b:current_syntax')
  finish
endif

" Always highlight vertical table separators, even inside column matches
syntax match HimalayaSeparator /[│┆|]/ containedin=ALL

" Detect table format and determine header / rule rows
if getline(1) =~# '^[┌+]'
  let s:hrow = 2
  let s:lstart = 4
else
  let s:hrow = 1
  let s:lstart = 3
endif

syntax match HimalayaRule /^[┌╞└+].*/ contains=HimalayaSeparator

" Header row
execute 'syntax match HimalayaHead /\%' . s:hrow . 'l.*/ contains=HimalayaSeparator'
highlight HimalayaHead term=bold cterm=bold gui=bold
highlight default link HimalayaRule WinSeparator

" Derive column boundaries from header separators
let s:header = getline(s:hrow)
let s:cols = []
let s:idx = 0

while 1
  let s:idx = match(s:header, '[│┆|]', s:idx)
  if s:idx == -1
    break
  endif
  call add(s:cols, s:idx + 1)
  let s:idx += len(matchstr(s:header, '^.', s:idx))
endwhile

if len(s:cols) >= 6

  let s:lend = getline(1) =~# '^[┌+]' ? '\%<' . line('$') . 'l' : ''

  execute 'syntax match HimalayaId /\%>' . (s:lstart - 1) . 'l' . s:lend
        \ . '\%>' . s:cols[0] . 'c'
        \ . '[^│┆|]*/'

  execute 'syntax match HimalayaFlags /\%>' . (s:lstart - 1) . 'l' . s:lend
        \ . '\%>' . s:cols[1] . 'c'
        \ . '[^│┆|]*/'

  execute 'syntax match HimalayaSubject /\%>' . (s:lstart - 1) . 'l' . s:lend
        \ . '\%>' . s:cols[2] . 'c'
        \ . '[^│┆|]*/'

  execute 'syntax match HimalayaSender /\%>' . (s:lstart - 1) . 'l' . s:lend
        \ . '\%>' . s:cols[3] . 'c'
        \ . '[^│┆|]*/'

  execute 'syntax match HimalayaDate /\%>' . (s:lstart - 1) . 'l' . s:lend
        \ . '\%>' . s:cols[4] . 'c'
        \ . '[^│┆|]*/'

  if len(s:cols) >= 7
    execute 'syntax match HimalayaSize /\%>' . (s:lstart - 1) . 'l' . s:lend
          \ . '\%>' . s:cols[5] . 'c'
          \ . '[^│┆|]*/'
  endif

endif

highlight default link HimalayaSeparator VertSplit
highlight default link HimalayaId        Identifier
highlight default link HimalayaFlags     Special
highlight default link HimalayaSubject   String
highlight default link HimalayaSender    Structure
highlight default link HimalayaDate      Constant
highlight default link HimalayaSize      Number

let b:current_syntax = 'himalaya-email-listing'
