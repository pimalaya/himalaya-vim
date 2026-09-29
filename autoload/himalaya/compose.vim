vim9script

# Writing buffers.
#
# A buffer holds the decoded template the CLI composes: a header block,
# a blank line, then the plain text body. Sending or saving hands it
# back through the composer flags, with one `--attach` per file of the
# buffer's attachment list, so the CLI builds the MIME message and
# appends the signature its config declares.

import autoload 'himalaya/account.vim'
import autoload 'himalaya/cli.vim'
import autoload 'himalaya/envelope.vim'
import autoload 'himalaya/mailbox.vim'
import autoload 'himalaya/message.vim'

const HEADERS = ['from', 'to', 'cc', 'bcc', 'subject']

export def New()
  cli.Json(account.Args() + ['message', 'compose'], 'Composing message', (template) => {
    Open({kind: 'compose'}, template, [])
  })
enddef

export def Reply()
  Derive('reply')
enddef

export def Forward()
  Derive('forward')
enddef

# Resumes the message under the cursor as a new message, its attachments
# downloaded next to it. The original is deleted once the resumed one is
# sent or saved.
export def Edit()
  const id = message.Id()
  if empty(id)
    return
  endif

  const source = {mailbox: mailbox.Current(), id: id}
  const dir = tempname()
  mkdir(dir, 'p')

  cli.Json(account.Args() + ['message', 'read'] + mailbox.Args() + [id], $'Reading message {id}', (parsed) => {
    const args = account.Args() + ['attachment', 'download'] + mailbox.Args() + ['--dir', dir, id]
    cli.Json(args, 'Downloading attachments', (data) => {
      const paths = mapnew(data.attachments, (_, attachment) => attachment.path)
      Open({kind: 'compose', draft: source, dir: dir}, Template(parsed), paths)
    })
  })
enddef

# Asks what to do with the buffer, on `:write`.
export def Submit()
  const choice = input('(s)end, (d)raft or (c)ancel? ')->tolower()
  redraw

  if choice =~ '^s'
    Send()
  elseif choice =~ '^d'
    SaveDraft()
  endif
enddef

export def Send()
  Deliver(['--send'], 'Sending message', true)
enddef

# Saves the buffer to the drafts mailbox. A draft carries no signature,
# since sending it once resumed appends one.
export def SaveDraft()
  Deliver(['--save', 'drafts', '--signature', ''], 'Saving draft', false)
enddef

export def AddAttachment()
  const path = input('Attach file: ', '', 'file')
  redraw
  if empty(path)
    return
  endif

  const owner = Owner()
  const expanded = fnamemodify(expand(path), ':p')

  if !filereadable(expanded)
    cli.Err($'Cannot read {expanded}')
    return
  endif

  add(getbufvar(owner, 'himalaya_compose').attachments, expanded)
  SyncAttachmentsBuffer(owner)
  redrawstatus!
enddef

# Opens the attachment list of the writing buffer, where `:write` applies
# the edited list.
export def OpenAttachments()
  const owner = Owner()
  const name = $'Himalaya attachments [{owner}]'

  if bufwinnr(name) > 0
    execute $':{bufwinnr(name)}wincmd w'
    return
  endif

  execute 'silent botright 8new' fnameescape(name)
  b:himalaya_owner = owner
  setlocal filetype=himalaya-attachments
  SyncAttachmentsBuffer(owner)
enddef

# Applies the edited attachment list to its writing buffer.
export def WriteAttachments()
  var paths = []

  for line in getline(1, '$')
    if empty(trim(line))
      continue
    endif
    const path = fnamemodify(expand(trim(line)), ':p')
    if !filereadable(path)
      cli.Err($'Cannot read {path}')
      return
    endif
    add(paths, path)
  endfor

  getbufvar(b:himalaya_owner, 'himalaya_compose').attachments = paths
  setlocal nomodified
  redrawstatus!
enddef

# The attachment count shown in the status line of a writing buffer.
export def Status(): string
  const count = len(get(get(b:, 'himalaya_compose', {}), 'attachments', []))
  return count == 0 ? '' : $'[{count} attachment{count > 1 ? "s" : ""}]'
enddef

# Removes the files downloaded for a resumed message.
export def Cleanup(buf: number)
  const dir = get(getbufvar(buf, 'himalaya_compose', {}), 'dir', '')
  if !empty(dir)
    delete(dir, 'rf')
  endif
enddef

export def CompleteContact(findstart: number, base: string): any
  if findstart
    const line = strpart(getline('.'), 0, col('.') - 1)
    var start = match(line, '[^:,]*$')
    while start < len(line) && line[start] == ' '
      start += 1
    endwhile
    return start
  endif

  const output = system(substitute(g:himalaya_complete_contact_cmd, '%s', base, ''))
  return split(output, "\n")->map((_, line) => ContactItem(line))
enddef

def Derive(kind: string)
  const id = message.Id()
  if empty(id)
    return
  endif

  const source = mailbox.Current()
  const args = account.Args() + ['message', kind] + mailbox.Args() + [id]
  cli.Json(args, $'Composing {kind}', (template) => {
    Open({kind: kind, mailbox: source, id: id}, template, [])
  })
enddef

def Open(meta: dict<any>, template: dict<any>, attachments: list<string>)
  const name = meta.kind == 'compose' ? 'Himalaya write' : $'Himalaya {meta.kind} [{meta.id}]'
  execute 'silent botright new' fnameescape(name)

  var lines = [
    $'From: {get(template, "from", "")}',
    $'To: {join(get(template, "to", []), ", ")}',
    $'Cc: {join(get(template, "cc", []), ", ")}',
    $'Bcc: {join(get(template, "bcc", []), ", ")}',
    $'Subject: {get(template, "subject", "")}',
    '',
  ]
  lines += split(substitute(get(template, 'body', ''), "\r", '', 'g'), "\n", true)
  while len(lines) > 6 && empty(lines[-1])
    remove(lines, -1)
  endwhile

  setline(1, lines)
  b:himalaya_compose = extend(meta, {account: account.Current(), attachments: attachments})
  setlocal buftype=acwrite
  setlocal filetype=himalaya-email-writing
  setlocal nomodified
  cursor(empty(get(template, 'to', [])) ? 2 : 7, 1)
enddef

def Deliver(extra: list<string>, msg: string, sent: bool)
  if !exists('b:himalaya_compose')
    cli.Err('Not a Himalaya writing buffer')
    return
  endif

  const buf = bufnr()
  const meta = b:himalaya_compose
  const parsed = Parse(getline(1, '$'))
  if empty(parsed)
    return
  endif

  const body = tempname()
  writefile(parsed.body, body)

  var args = empty(meta.account) ? [] : ['--account', meta.account]
  if meta.kind == 'compose'
    args += ['message', 'compose']
  else
    args += ['message', meta.kind]
    args += empty(meta.mailbox) ? [] : ['--mailbox', meta.mailbox]
    args += [meta.id, '--posting-style', 'none']
  endif

  if !empty(parsed.from)
    args += ['--from', parsed.from]
  endif
  for header in ['to', 'cc', 'bcc']
    if !empty(parsed[header])
      args += [$'--{header}', parsed[header]]
    endif
  endfor
  args += ['--subject', parsed.subject, '--body-file', body]
  for path in meta.attachments
    args += ['--attach', path]
  endfor

  cli.Run(args + extra, msg, (_) => {
    Delivered(buf, meta, sent)
  }, () => {
    delete(body)
  })
enddef

def Delivered(buf: number, meta: dict<any>, sent: bool)
  const accountArgs = empty(meta.account) ? [] : ['--account', meta.account]

  if sent && meta.kind == 'reply'
    var args = accountArgs + ['flag', 'add']
    args += empty(meta.mailbox) ? [] : ['--mailbox', meta.mailbox]
    cli.Run(args + [meta.id, '--flag', 'answered'], 'Flagging message answered', (_) => {
      envelope.Refresh()
    })
  endif

  if has_key(meta, 'draft')
    var args = accountArgs + ['message', 'delete']
    args += empty(meta.draft.mailbox) ? [] : ['--mailbox', meta.draft.mailbox]
    cli.Run(args + [meta.draft.id], 'Deleting resumed message', (_) => {
      envelope.Refresh()
    })
  endif

  if bufexists(buf)
    execute 'bwipeout!' buf
  endif
  envelope.Refresh()
enddef

# Splits a writing buffer into its headers and body lines, empty when a
# header is unknown.
def Parse(lines: list<string>): dict<any>
  var parsed: dict<any> = {from: '', to: '', cc: '', bcc: '', subject: '', body: []}
  var last = ''
  var lnum = 0

  while lnum < len(lines) && !empty(lines[lnum])
    const line = lines[lnum]
    if line =~ '^\s' && !empty(last)
      parsed[last] = trim($'{parsed[last]} {trim(line)}')
    else
      const name = tolower(matchstr(line, '^[^:]*'))
      if index(HEADERS, name) < 0
        cli.Err($'Unsupported header `{matchstr(line, "^[^:]*")}`, expected From, To, Cc, Bcc or Subject')
        return {}
      endif
      parsed[name] = trim(matchstr(line, ':\zs.*'))
      last = name
    endif
    lnum += 1
  endwhile

  parsed.body = lines[lnum + 1 :]
  return parsed
enddef

# Lays a message parsed by `message read --json` out as a template.
def Template(parsed: dict<any>): dict<any>
  var template: dict<any> = {to: [], cc: [], bcc: [], body: ''}

  for header in get(get(parsed, 'parts', [{}])[0], 'headers', [])
    const name = type(header.name) == v:t_string ? header.name : ''
    if name == 'from'
      template.from = get(Mailboxes(header.value), 0, '')
    elseif index(['to', 'cc', 'bcc'], name) >= 0
      template[name] = Mailboxes(header.value)
    elseif name == 'subject'
      template.subject = get(header.value, 'Text', '')
    endif
  endfor

  const text = get(parsed, 'text_body', [])
  if !empty(text)
    const body = parsed.parts[text[0]].body
    template.body = get(body, 'Text', get(body, 'Html', ''))
  endif

  return template
enddef

def Mailboxes(value: dict<any>): list<string>
  const address = get(value, 'Address', {})
  var addrs = get(address, 'List', [])
  for group in get(address, 'Group', [])
    addrs += get(group, 'addresses', [])
  endfor
  return mapnew(addrs, (_, addr) => Mailbox(addr))
enddef

# Formats a mailbox the way the composer flags parse it back, quoting a
# display name that holds an RFC 5322 special.
def Mailbox(addr: dict<any>): string
  const email = get(addr, 'address', '')
  const name = get(addr, 'name', '')
  if empty(name)
    return email
  endif
  if name =~ '[()<>[\]:;@\\,."]'
    return $'"{escape(name, "\\\"")}" <{email}>'
  endif
  return $'{name} <{email}>'
enddef

def Owner(): number
  return exists('b:himalaya_owner') ? b:himalaya_owner : bufnr()
enddef

def SyncAttachmentsBuffer(owner: number)
  const buf = bufnr($'Himalaya attachments [{owner}]')
  if buf < 0
    return
  endif
  deletebufline(buf, 1, '$')
  setbufline(buf, 1, getbufvar(owner, 'himalaya_compose').attachments)
  setbufvar(buf, '&modified', false)
enddef

def ContactItem(line: string): string
  const fields = split(line, '\t')
  return len(fields) > 1 ? $'"{fields[1]}" <{fields[0]}>' : $'<{fields[0]}>'
enddef
