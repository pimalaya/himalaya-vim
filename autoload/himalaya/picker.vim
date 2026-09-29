vim9script

import autoload 'himalaya/cli.vim'

# Lets the user pick one of the items, then calls OnSelect with it.
#
# The picker comes from `g:himalaya_<kind>_picker`, `native` or `fzf`,
# defaulting to fzf when fzf.vim is installed.
export def Pick(kind: string, items: list<string>, OnSelect: func(string))
  const fallback = exists('*fzf#run') ? 'fzf' : 'native'
  const picker = get(g:, $'himalaya_{kind}_picker', fallback)

  if picker == 'fzf'
    fzf#run({source: items, sink: OnSelect, down: '25%'})
  elseif picker == 'native'
    popup_menu(items, {
      title: $' {kind} ',
      callback: (_, index) => {
        if index > 0
          OnSelect(items[index - 1])
        endif
      },
    })
  else
    cli.Err($'Unknown {kind} picker `{picker}`, expected `native` or `fzf`')
  endif
enddef
