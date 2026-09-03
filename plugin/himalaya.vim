if exists('g:himalaya_loaded')
  finish
endif

let default_executable = 'himalaya'
let himalaya = get(g:, 'himalaya_executable', default_executable)

if !executable(himalaya)
  throw 'Himalaya CLI not found, see https://pimalaya.org/himalaya/cli/latest/installation/'
endif

let g:himalaya_executable = 'RUST_LOG=off ' . himalaya

" Backup cpo
let s:cpo_backup = &cpo
set cpo&vim

command! -nargs=* Himalaya             call himalaya#domain#email#list(<f-args>)
command! -nargs=* HimalayaCopy         call himalaya#domain#email#select_mailbox_then_copy()
command! -nargs=* HimalayaMove         call himalaya#domain#email#select_mailbox_then_move()
command! -nargs=* HimalayaDelete       call himalaya#domain#email#delete()
command! -nargs=* HimalayaWrite        call himalaya#domain#email#write()
command! -nargs=* HimalayaReply        call himalaya#domain#email#reply()
command! -nargs=* HimalayaForward      call himalaya#domain#email#forward()
command! -nargs=* HimalayaAccounts     call himalaya#domain#account#select()
command! -nargs=1 HimalayaAccount      call himalaya#domain#account#set(<f-args>)
command! -nargs=* HimalayaMailboxes    call himalaya#domain#mailbox#select()
command! -nargs=1 HimalayaMailbox      call himalaya#domain#mailbox#set(<f-args>)
command! -nargs=* HimalayaFolders      call himalaya#domain#mailbox#select()
command! -nargs=1 HimalayaFolder       call himalaya#domain#mailbox#set(<f-args>)
command! -nargs=* HimalayaNextPage     call himalaya#domain#mailbox#select_next_page()
command! -nargs=* HimalayaPreviousPage call himalaya#domain#mailbox#select_previous_page()
command! -nargs=* HimalayaAttachments  call himalaya#domain#email#download_attachments()
command! -nargs=* HimalayaFlagAdd      call himalaya#domain#email#flag_add()
command! -nargs=* HimalayaFlagRemove   call himalaya#domain#email#flag_remove()

" Restore cpo
let &cpo = s:cpo_backup
unlet s:cpo_backup

let g:himalaya_loaded = 1
