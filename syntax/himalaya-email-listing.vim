vim9script

if exists('b:current_syntax')
  finish
endif

# Columns are located by the names of the header row, so optional ones
# (ATT, TO instead of FROM) and any table preset highlight right.

const SEPARATOR = '[│┆|]'
const GROUPS = {
  ID: 'HimalayaId',
  FLAGS: 'HimalayaFlags',
  ATT: 'HimalayaAtt',
  SUBJECT: 'HimalayaSubject',
  FROM: 'HimalayaSender',
  TO: 'HimalayaSender',
  DATE: 'HimalayaDate',
  SIZE: 'HimalayaSize',
}

syntax match HimalayaSeparator /[│┆|]/ contained
syntax match HimalayaRule /^[┌╞├└╘╒+].*/

var head = 0
for lnum in range(1, line('$'))
  if getline(lnum) =~ $'^{SEPARATOR}\s*ID\s*{SEPARATOR}'
    head = lnum
    break
  endif
endfor

if head > 0
  const header = getline(head)
  var separators: list<number> = []
  var vcol = 1
  for char in split(header, '\zs')
    if char =~ SEPARATOR
      add(separators, vcol)
    endif
    vcol += strdisplaywidth(char)
  endfor

  const names = split(header, SEPARATOR)->map((_, name) => trim(name))
  var cells: list<string> = []

  for i in range(len(separators) - 1)
    const group = get(GROUPS, get(names, i, ''), '')
    if !empty(group)
      const [start, end] = [separators[i] + 1, separators[i + 1]]
      execute $'syntax match {group} /\%{start}v.*\ze\%{end}v/ contained'
      add(cells, group)
    endif
  endfor

  execute $'syntax match HimalayaHead /\%{head}l.*/ contains=HimalayaSeparator'
  execute $'syntax match HimalayaRow /\%>{head}l^{SEPARATOR}.*/ contains=HimalayaSeparator,{join(uniq(sort(cells)), ",")}'
endif

highlight default HimalayaHead term=bold cterm=bold gui=bold
highlight default link HimalayaSeparator VertSplit
highlight default link HimalayaRule VertSplit
highlight default link HimalayaId Identifier
highlight default link HimalayaFlags Special
highlight default link HimalayaAtt Special
highlight default link HimalayaSubject String
highlight default link HimalayaSender Structure
highlight default link HimalayaDate Constant
highlight default link HimalayaSize Number

b:current_syntax = 'himalaya-email-listing'
