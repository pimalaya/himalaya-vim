let s:print_info = function("himalaya#utils#print_msg")
let s:print_err = function("himalaya#utils#print_err")
let s:exec = function("himalaya#shared#exec")

function! himalaya#mbox#input()
  try
    call s:print_info("Fetching mailboxes…")

    let mboxes = map(s:exec("himalaya --output json mailboxes", []), "v:val.name")

    if &rtp =~ "fzf.vim"
      call fzf#run({
        \"source": mboxes,
        \"sink": function("himalaya#mbox#post_input"),
        \"down": "25%",
      \})
    else
      let choice = map(copy(mboxes), "printf('%s (%d)', v:val, v:key)")
      let choice = input(join(choices, ", ") . ": ")
      call himalaya#mbox#post_input(mboxes[choice])
    endif
  catch
    call s:print_err(v:exception)
  endtry
endfunction

function! himalaya#mbox#post_input(mbox)
  call himalaya#msg#set_mbox(a:mbox)
  call himalaya#msg#set_page(0)
  call himalaya#msg#list()
endfunction
