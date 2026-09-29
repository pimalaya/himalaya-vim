vim9script

# Maps each key to its `<Plug>(himalaya-*)` mapping in the current
# buffer, unless the user already mapped that plug somewhere.
export def Define(bindings: list<list<string>>)
  for [mode, key, name] in bindings
    const plug = $'<Plug>(himalaya-{name})'
    if !hasmapto(plug, mode)
      execute $'{mode}map <buffer><nowait> {key} {plug}'
    endif
  endfor
enddef
