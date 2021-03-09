function! himalaya#shared#define_bindings(bindings)
  for [mode, key, name] in a:bindings
    let name = printf("himalaya-%s", name)
    let plug = printf("<plug>(%s)", name)

    let fn = substitute(name, "-", "#", "g")
    execute printf("%snoremap <silent>%s :call %s()<cr>", mode, plug, fn)

    if !hasmapto(plug, mode)
      execute printf("%smap <nowait><buffer>%s %s", mode, key, plug)
    endif
  endfor
endfunction

function! himalaya#shared#exec(cmd, args)
  let cmd = call("printf", [a:cmd] + a:args)
  let res = system(cmd)

  if !empty(res)
    try
      return eval(res)
    catch
      throw res
    endtry
  endif
endfunction
