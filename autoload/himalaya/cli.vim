vim9script

# Runs the Himalaya CLI asynchronously, one job per request.
#
# The CLI prints data and errors on stdout and logs on stderr, so the
# exit code alone tells a failure apart. Arguments are passed as a list,
# never through a shell, so a query or a path needs no escaping.

export def Info(msg: string)
  echohl None
  echomsg msg
enddef

export def Warn(msg: string)
  echohl WarningMsg
  echomsg msg
  echohl None
enddef

export def Err(msg: string)
  echohl ErrorMsg
  echomsg msg
  echohl None
enddef

# Runs the CLI with the given arguments, handing its stdout to OnData on
# success. OnExit runs once the job ends, whatever its outcome.
export def Run(args: list<string>, msg: string, OnData: func(string), OnExit: func() = null_function)
  const cmd = Command(args)

  if !executable(cmd[0])
    Err($'Himalaya CLI not found: {cmd[0]}')
    return
  endif

  Info($'{msg}…')

  var state: dict<any> = {out: [], err: [], status: -1, closed: false, done: false}

  const Finish = () => {
    if state.status < 0 || !state.closed || state.done
      return
    endif
    state.done = true
    Complete(state, msg, OnData, OnExit)
  }

  const job = job_start(cmd, {
    in_io: 'null',
    out_mode: 'raw',
    err_mode: 'raw',
    out_cb: (_, chunk) => {
      add(state.out, chunk)
    },
    err_cb: (_, chunk) => {
      add(state.err, chunk)
    },
    exit_cb: (_, status) => {
      state.status = status
      Finish()
    },
    close_cb: (_) => {
      state.closed = true
      Finish()
    },
  })

  if job_status(job) == 'fail'
    Err($'{msg} failed: cannot start {cmd[0]}')
    if OnExit != null_function
      OnExit()
    endif
  endif
enddef

# Runs the CLI with `--json` and hands the decoded stdout to OnData.
export def Json(args: list<string>, msg: string, OnData: func(any), OnExit: func() = null_function)
  Run(['--json'] + args, msg, (out) => {
    OnData(json_decode(out))
  }, OnExit)
enddef

def Command(args: list<string>): list<string>
  var cmd = [get(g:, 'himalaya_executable', 'himalaya')]

  if exists('g:himalaya_config_path')
    cmd += ['--config', expand(g:himalaya_config_path)]
  endif

  return cmd + args
enddef

def Complete(state: dict<any>, msg: string, OnData: func(string), OnExit: func())
  try
    if state.status == 0
      OnData(join(state.out, ''))
      redraw
      Info($'{msg} [OK]')
    else
      redraw
      Err($'{msg} failed:')
      ReportError(join(state.out, ''), join(state.err, ''))
    endif
  catch
    Err(v:exception)
  finally
    if OnExit != null_function
      OnExit()
    endif
  endtry
enddef

# Shows the error report the CLI printed on stdout, then its logs.
def ReportError(out: string, err: string)
  var report: any = null

  try
    report = json_decode(out)
  catch
  endtry

  if type(report) == v:t_dict && has_key(report, 'error')
    Err(report.error)
    for source in get(report, 'sources', [])
      Err($'  {source}')
    endfor
  else
    for line in split(out, "\n")
      Err(line)
    endfor
  endif

  for line in split(err, "\n")
    Warn(line)
  endfor
enddef
