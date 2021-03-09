let s:print_info = function("himalaya#utils#print_msg")
let s:print_err = function("himalaya#utils#print_err")
let s:trim = function("himalaya#utils#trim")
let s:exec = function("himalaya#shared#exec")

let s:curr_msg_id = 0
let s:draft = ""

" Current mailbox

let s:mbox = "INBOX"

function! himalaya#msg#set_mbox(mbox)
  let s:mbox = a:mbox
endfunction

" Current page

let s:page = 0

function! himalaya#msg#set_page(page)
  let s:page = a:page
endfunction

" Functions

function! himalaya#msg#list()
  try
    call s:print_info(printf("Fetching %s page %d…", s:mbox, s:page + 1))

    let prev_pos = getpos(".")
    let msgs = s:exec("himalaya --output json list --mailbox %s --page %d", [shellescape(s:mbox), s:page])
    let bufname = printf("Himalaya messages [%s] [page %d]", s:mbox, s:page + 1)
    execute printf("silent! %s %s", stridx(bufname("%"), "Himalaya") == 0 ? "file" : "edit", bufname)

    setlocal modifiable
    execute "%d"
    call append(0, s:render("list", msgs))
    execute "$d"
    setlocal nomodifiable

    call setpos(".", prev_pos)
    setlocal filetype=himalaya-msg-list
    let &modified = 0

    call s:print_info("Done!")
  catch
    call s:print_err(v:exception)
  endtry
endfunction

function! himalaya#msg#prev()
  let s:page = max([0, s:page - 1])
  call himalaya#msg#list()
endfunction

function! himalaya#msg#next()
  let s:page = s:page + 1
  call himalaya#msg#list()
endfunction

function! himalaya#msg#read()
    let s:curr_msg_id = s:get_focused_msg()
    call s:print_info(printf("Fetching message %d…", s:curr_msg_id))

    let prev_pos = getpos(".")
    let msg = s:exec(printf("himalaya --output json read %d", s:curr_msg_id), [])

    silent! bwipeout "Message"
    silent! edit Message

    call append(0, split(substitute(msg.content, "\r", "", "g"), "\n"))
    execute "$d"

    call setpos(".", prev_pos)
    setlocal filetype=himalaya-msg-read
    let &modified = 0

    call s:print_info("Done!")
endfunction

function! himalaya#msg#write()
    call s:print_info("Fetching template…")

    let prev_pos = getpos(".")
    let msg = s:exec("himalaya --output json template new", [])

    silent! bwipeout "Write"
    silent! edit Write

    call append(0, split(substitute(msg.template, "\r", "", "g"), "\n"))
    execute "$d"

    call setpos(".", prev_pos)
    setlocal filetype=himalaya-msg-write
    let &modified = 0

    call s:print_info("Done!")
endfunction

function! himalaya#msg#reply()
    call s:print_info("Fetching template…")

    let prev_pos = getpos(".")
    let msg = s:exec(printf("himalaya --output json template reply %d", s:curr_msg_id), [])

    silent! bwipeout "Reply"
    silent! edit Reply

    call append(0, split(substitute(msg.template, "\r", "", "g"), "\n"))
    execute "$d"

    call setpos(".", prev_pos)
    setlocal filetype=himalaya-msg-write
    let &modified = 0

    call s:print_info("Done!")
endfunction

function! himalaya#msg#reply_all()
    call s:print_info("Fetching template…")

    let prev_pos = getpos(".")
    let msg = s:exec(printf("himalaya --output json template reply %d --all", s:curr_msg_id), [])

    silent! bwipeout "Reply all"
    silent! edit "Reply all"

    call append(0, split(substitute(msg.template, "\r", "", "g"), "\n"))
    execute "$d"

    call setpos(".", prev_pos)
    setlocal filetype=himalaya-msg-write
    let &modified = 0

    call s:print_info("Done!")
endfunction

function! himalaya#msg#forward()
    call s:print_info("Fetching template…")

    let prev_pos = getpos(".")
    let msg = s:exec(printf("himalaya --output json template forward %d", s:curr_msg_id), [])

    silent! bwipeout "Forward"
    silent! edit Forward

    call append(0, split(substitute(msg.template, "\r", "", "g"), "\n"))
    execute "$d"

    call setpos(".", prev_pos)
    setlocal filetype=himalaya-msg-write
    let &modified = 0

    call s:print_info("Done!")
endfunction

function! himalaya#msg#draft_save()
  let s:draft = join(getline(1, "$"), "\r\n")
  call s:print_info("Draft saved!")
  let &modified = 0
endfunction

function! himalaya#msg#draft_handle()
  while 1
    let choice = input("(s)end, (d)raft, (q)uit or (c)ancel? ")
    let choice = tolower(choice)[0]
    redraw | echo

    if choice == "s"
      call s:print_info("Sending message…")
      call s:exec(printf("himalaya --output json send -- %s", shellescape(s:draft)), [])
      call s:print_info("Done!")
      return
    elseif choice == "d"
      call s:print_info("Saving draft…")
      call s:exec(printf("himalaya --output json save --mailbox Drafts -- %s", shellescape(s:draft)), [])
      call s:print_info("Done!")
      return
    elseif choice == "q"
      return
    elseif choice == "c"
      throw "Action canceled"
    endif
  endwhile
endfunction

" Render utils

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

function! s:get_focused_msg()
  try
    return s:trim(split(getline("."), "|")[0])
  catch
    throw "message not found"
  endtry
endfunction
