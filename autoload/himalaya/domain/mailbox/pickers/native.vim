" Represents the mailbox picker based the standard vim function
" input. See `help input`.
function! himalaya#domain#mailbox#pickers#native#select(callback, mailboxes) abort
  let mailboxes = map(copy(a:mailboxes), 'printf("%s (%d)", v:val.name, v:key)')

  let mailbox_index = input(join(mailboxes, ', ') . ': ')
  if mailbox_index == ''
    throw 'Action aborted!'
  endif

  redraw | echo
  call function(a:callback)(a:mailboxes[mailbox_index].name)
endfunction
