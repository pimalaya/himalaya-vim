vim9script

import autoload 'himalaya/account.vim'
import autoload 'himalaya/cli.vim'
import autoload 'himalaya/envelope.vim'
import autoload 'himalaya/mailbox.vim'

const FLAGS = ['seen', 'answered', 'flagged', 'draft']

# The ids a command acts on: the listing rows between the given lines,
# or the message shown in a reading buffer.
export def Ids(first: number, last: number): list<string>
  if &filetype == 'himalaya-email-listing'
    return envelope.Ids(first, last)
  endif
  if exists('b:himalaya_id')
    return [b:himalaya_id]
  endif
  return []
enddef

# The single id a command acts on, empty when there is none.
export def Id(): string
  return get(Ids(line('.'), line('.')), 0, '')
enddef

export def Read()
  const id = envelope.IdAt(line('.'))
  if empty(id)
    return
  endif

  const args = account.Args() + ['message', 'read', '--seen'] + mailbox.Args() + [id]
  cli.Run(args, $'Reading message {id}', (out) => {
    Show(id, out)
  })
enddef

export def SelectMailboxThenCopy(first: number, last: number)
  const ids = Ids(first, last)
  if !empty(ids)
    mailbox.Pick((target, _) => {
      Transfer('copy', ids, target)
    })
  endif
enddef

export def SelectMailboxThenMove(first: number, last: number)
  const ids = Ids(first, last)
  if !empty(ids)
    mailbox.Pick((target, _) => {
      if Confirm($'Move message(s) {join(ids)}?')
        Transfer('move', ids, target)
      endif
    })
  endif
enddef

export def Delete(first: number, last: number)
  const ids = Ids(first, last)
  if empty(ids) || !Confirm($'Delete message(s) {join(ids)}?')
    return
  endif

  const reading = exists('b:himalaya_id') ? bufnr() : -1
  const args = account.Args() + ['message', 'delete'] + mailbox.Args() + ids
  cli.Run(args, 'Deleting message(s)', (_) => {
    if reading > 0 && bufexists(reading)
      execute 'bwipeout' reading
    endif
    envelope.Refresh()
  })
enddef

export def FlagAdd(first: number, last: number)
  Flag('add', Ids(first, last))
enddef

export def FlagRemove(first: number, last: number)
  Flag('remove', Ids(first, last))
enddef

export def CompleteFlags(lead: string, line: string, pos: number): list<string>
  return FLAGS->copy()->filter((_, flag) => flag =~ $'^{lead}')
enddef

export def DownloadAttachments()
  const id = Id()
  if empty(id)
    return
  endif

  const args = account.Args() + ['attachment', 'download'] + mailbox.Args() + [id]
  cli.Json(args, 'Downloading attachments', (data) => {
    for attachment in data.attachments
      cli.Info($'Downloaded {attachment.path}')
    endfor
  })
enddef

def Show(id: string, out: string)
  for buf in getbufinfo()
    if buf.name =~ 'Himalaya read message'
      execute 'bwipeout' buf.bufnr
    endif
  endfor

  execute 'silent botright new' fnameescape($'Himalaya read message [{id}]')
  setline(1, split(substitute(out, "\r", '', 'g'), "\n"))
  b:himalaya_id = id
  setlocal filetype=himalaya-email-reading
  setlocal nomodifiable nomodified
  cursor(1, 1)
enddef

def Transfer(verb: string, ids: list<string>, target: string)
  const source = mailbox.Current()
  var args = account.Args() + ['message', verb] + ids
  args += empty(source) ? [] : ['--from', source]
  args += ['--to', target]

  cli.Run(args, $'Running message {verb}', (_) => {
    envelope.Refresh()
  })
enddef

def Flag(verb: string, ids: list<string>)
  if empty(ids)
    return
  endif

  const flags = input($'Flags to {verb}: ', '', 'customlist,himalaya#message#CompleteFlags')->split()
  redraw
  if empty(flags)
    return
  endif

  var args = account.Args() + ['flag', verb] + mailbox.Args() + ids
  for flag in flags
    args += ['--flag', flag]
  endfor

  cli.Run(args, $'Running flag {verb}', (_) => {
    envelope.Refresh()
  })
enddef

def Confirm(question: string): bool
  if !get(g:, 'himalaya_always_confirm', true)
    return true
  endif
  const answer = input($'{question} (y/N) ')
  redraw
  return answer ==? 'y'
enddef
