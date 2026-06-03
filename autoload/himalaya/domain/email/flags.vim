function! himalaya#domain#email#flags#complete(ArgLead, CmdLine, CursorPos) abort
    return join(['seen', 'answered', 'flagged', 'draft'], "\n")
endfunction
