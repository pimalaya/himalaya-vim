function! s:exec(cmd, args)
  let cmd = call("printf", [a:cmd] + a:args)
  let result = eval(system(cmd))

  if result.success == 0
    throw result.message
  endif

  return result
endfunction

function! himalaya#task#info(id)
  return s:exec("himalaya info %s --json", [shellescape(a:id)]).task
endfunction

function! himalaya#task#list()
  return s:exec("himalaya list --json", []).tasks
endfunction

function! himalaya#task#list_done()
  return s:exec("himalaya list --done --json", []).tasks
endfunction

function! himalaya#task#list_deleted()
  return s:exec("himalaya list --deleted --json", []).tasks
endfunction

function! himalaya#task#add(task)
  let desc = shellescape(a:task.desc)
  let proj = shellescape(a:task.project)
  let due = shellescape(a:task.due)

  return s:exec("himalaya add %s --project %s --due %s --json", [desc, proj, due]).message
endfunction

function! himalaya#task#edit(task)
  let args = [a:task.id]
  if !empty(a:task.desc) | call add(args, shellescape(a:task.desc)) | endif
  if !empty(a:task.project) | call add(args, "--project " . shellescape(a:task.project)) | endif
  if !empty(a:task.due) | call add(args, "--due " . shellescape(a:task.due)) | endif

  return s:exec("himalaya edit %s --json", [join(args, " ")]).message
endfunction

function! himalaya#task#toggle(id)
  return s:exec("himalaya toggle %s --json", [shellescape(a:id)]).message
endfunction

function! himalaya#task#do(id)
  return s:exec("himalaya do %s --json", [shellescape(a:id)]).message
endfunction

function! himalaya#task#context(context)
  return s:exec("himalaya context %s --json", [a:context]).message
endfunction

function! himalaya#task#context_completion()
  return filter(systemlist("himalaya --bash-completion-index 2 --bash-completion-word himalaya --bash-completion-word context"), "match(v:val, '^-') == -1")
endfunction

function! himalaya#task#worktime(proj)
  return s:exec("himalaya worktime %s --json", [shellescape(a:proj)])
endfunction

function! himalaya#task#format_for_list(task)
  let task = copy(a:task)
  let task.active = empty(task.active.micro) ? "" : task.active.approx
  let task.due = empty(task.due.micro) ? "" : task.due.approx
  let task.worktime = empty(task.worktime.micro) ? "" : task.worktime.approx

  return task
endfunction
