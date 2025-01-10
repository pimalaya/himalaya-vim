function! himalaya#domain#email#flags#complete(ArgLead, CmdLine, CursorPos) abort
    let default_email_flags = ['seen', 'answered', 'flagged', 'deleted', 'drafts']

    let g:himalaya_custom_email_flags = get(g:, 'himalaya_custom_email_flags', [])
    let all_flags = default_email_flags + g:himalaya_custom_email_flags

    let prev_space = strridx(a:ArgLead[:a:CursorPos], ' ')
    let prefix = a:ArgLead[:prev_space]
    let inserted_flags = split(prefix)
    let filtered_flags = filter(all_flags, 'index(inserted_flags, v:val) < 0')
    let prefixed = map(filtered_flags, 'prev_space > 0? prefix . v:val : v:val')
    
    return join(prefixed, "\n")
endfunction

