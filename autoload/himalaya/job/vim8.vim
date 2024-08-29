let s:stdout = []
let s:stderr = []

function! himalaya#job#vim8#start(cmd, on_data) abort
  if v:version < 800 | throw 'incompatible vim version' | endif
  if !has('job') | throw 'job feature missing' | endif
  if !has('channel') | throw 'channel feature missing' | endif

  let s:stdout = []
  let s:stderr = []
  
  let cmd = split(a:cmd, ' -- ')  
  let job = job_start(['/bin/sh', '-c', cmd[0]], {
  \ 'out_mode': 'nl',
  \ 'out_cb': {_, line -> s:on_out(line)},
  \ 'err_cb': {_, line -> s:on_err(line)},
  \ 'close_cb': {-> s:on_close(a:on_data)},
  \})

  if len(cmd) > 1
    let channel = job_getchannel(job)
    call ch_sendraw(channel, join(cmd[1:], ' -- '))
    call ch_close_in(channel)
  endif
endfunction

function! s:on_out(line) abort
  let s:stdout += [a:line]
endfunction

function! s:on_err(line) abort
  let s:stderr += [a:line]
endfunction

function! s:on_close(callback) abort
  if !empty(s:stderr)
    for line in s:stderr
      call himalaya#log#err(line)
    endfor
    redraw
    throw 'CLI error, see :messages for more information'
  endif
  call a:callback(s:stdout)
endfunction
