let s:print_err = function("himalaya#utils#print_err")
let s:print_info = function("himalaya#utils#print_msg")

let s:buff_name = "Himalaya"

" Exec utils

function! s:exec(cmd, args)
  let cmd = call("printf", [a:cmd] + a:args)
  let res = system(cmd)

  try
    return eval(res)
  catch
    throw res
  endtry
endfunction

" Render utils

function! s:render(type, lines)
  let s:max_widths = s:get_max_widths(a:lines, s:config[a:type].columns)
  let header = [s:render_line(s:config.labels, s:max_widths, a:type)]
  let line = map(copy(a:lines), "s:render_line(v:val, s:max_widths, a:type)")

  return header + line
endfunction

function! s:render_line(line, max_widths, type)
  return "|" . join(map(
    \copy(s:config[a:type].columns),
    \"s:render_cell(a:line[v:val], a:max_widths[v:key])",
  \), "")
endfunction

function! s:render_cell(cell, max_width)
  let cell_width = strdisplaywidth(a:cell[:a:max_width])
  return a:cell[:a:max_width] . repeat(" ", a:max_width - cell_width) . " |"
endfunction

function! s:get_max_widths(msgs, columns)
  let max_widths = map(copy(a:columns), "strlen(s:config.labels[v:val])")

  for msg in a:msgs
    let widths = map(copy(a:columns), "strlen(msg[v:val])")
    call map(max_widths, "max([widths[v:key], v:val])")
  endfor

  return max_widths
endfunction

" List

let s:config = {
  \"list": {
    \"columns": ["uid", "subject", "sender", "date"],
  \},
  \"labels": {
    \"uid": "UID",
    \"subject": "SUBJECT",
    \"sender": "SENDER",
    \"date": "DATE",
  \},
\}

function! himalaya#msg#list(mbx)
  try
    call s:print_info(printf('Fetching %s messages…', a:mbx))

    let prev_pos = getpos(".")
    let msgs = s:exec(printf('himalaya --output json  list --mailbox "%s"', a:mbx), [])

    silent! bwipeout "Messages"
    silent! edit Messages

    call append(0, s:render("list", msgs))
    execute "$d"

    call setpos(".", prev_pos)
    setlocal filetype=himalaya-msg-list
    let &modified = 0
    echo
  catch
    call s:print_err(v:exception)
  endtry
endfunction
