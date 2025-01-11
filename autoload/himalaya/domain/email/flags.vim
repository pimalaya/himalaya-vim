function! himalaya#domain#email#flags#complete(ArgLead, CmdLine, CursorPos) abort
    let default_email_flags = ['seen', 'answered', 'flagged', 'deleted', 'drafts']

    let g:himalaya_custom_email_flags = get(g:, 'himalaya_custom_email_flags', [])
    let all_flags = default_email_flags + g:himalaya_custom_email_flags

    return join(all_flags, "\n")
endfunction

