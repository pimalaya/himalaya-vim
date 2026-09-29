vim9script

# Runs the plugin against the stub CLI of tests/bin, headless:
#
#   vim -Nu NONE -i NONE -es -S tests/run.vim

const root = expand('<sfile>:p:h:h')
execute 'set runtimepath^=' .. fnameescape(root)
filetype plugin on
syntax on

g:himalaya_executable = $'{root}/tests/bin/himalaya'
g:himalaya_always_confirm = false
$HIMALAYA_STUB_LOG = tempname()

runtime plugin/himalaya.vim

import autoload 'himalaya/compose.vim'
import autoload 'himalaya/envelope.vim'

def Calls(): list<list<string>>
  if !filereadable($HIMALAYA_STUB_LOG)
    return []
  endif
  return readfile($HIMALAYA_STUB_LOG)->map((_, line) => split(line, "\x1f", true)[: -2])
enddef

def CallWith(arg: string): list<string>
  return get(Calls()->filter((_, call) => index(call, arg) >= 0), -1, [])
enddef

def Flag(call: list<string>, name: string): string
  const i = index(call, name)
  return i < 0 ? '<none>' : call[i + 1]
enddef

def WaitFor(Cond: func(): bool, what: string)
  var i = 0
  while !Cond() && i < 300
    sleep 10m
    i += 1
  endwhile
  if !Cond()
    add(v:errors, $'Timed out waiting for {what}')
  endif
enddef

def Reset()
  silent! :%bwipeout!
  delete($HIMALAYA_STUB_LOG)
  messages clear
enddef

def OpenListing()
  Himalaya
  WaitFor(() => bufname() =~ 'Himalaya envelopes', 'the listing')
enddef

def Test_listing_parses_ids_and_highlights_columns()
  Reset()
  OpenListing()

  assert_equal(['envelope', 'list', '--page', '1'], Calls()[-1][: 3])
  assert_equal(['12', '13'], envelope.Ids(1, line('$')))
  assert_equal(4, line('.'))
  assert_equal('HimalayaSubject', synIDattr(synID(4, stridx(getline(4), 'Réunion') + 1, 1), 'name'))
  assert_equal('HimalayaDate', synIDattr(synID(5, stridx(getline(5), '2026') + 1, 1), 'name'))
enddef

def Test_search_passes_the_query_as_one_argument()
  Reset()
  envelope.Search('from "alice smith"')
  WaitFor(() => bufname() =~ 'Himalaya envelopes', 'the search')

  assert_equal(['envelope', 'search'], Calls()[-1][: 1])
  assert_equal('from "alice smith"', Calls()[-1][-1])

  envelope.Search('')
  WaitFor(() => Calls()[-1][: 1] == ['envelope', 'list'], 'the listing back')
enddef

def Test_failure_shows_the_stdout_error_and_the_logs()
  Reset()
  $HIMALAYA_STUB_FAIL = '1'
  envelope.List()
  WaitFor(() => execute('messages') =~ 'root cause', 'the error')
  $HIMALAYA_STUB_FAIL = ''

  assert_match('Boom', execute('messages'))
  assert_match('something logged', execute('messages'))
enddef

def Test_compose_sends_headers_body_and_attachments_as_flags()
  Reset()
  compose.New()
  WaitFor(() => &filetype == 'himalaya-email-writing', 'the writing buffer')

  assert_equal([
    'From: Me <me@example.org>',
    'To: Alice <a@example.org>',
    'Cc: ',
    'Bcc: ',
    'Subject: Re: Réunion',
    '',
    '> hello',
  ], getline(1, '$'))

  setline(3, 'Cc: "Doe, J." <j@example.org>')
  append('$', 'my answer')
  const file = tempname()
  writefile(['x'], file)
  b:himalaya_compose.attachments = [file]
  const buf = bufnr()

  compose.Send()
  WaitFor(() => !bufexists(buf), 'the buffer to be wiped')

  const send = CallWith('--send')
  assert_equal(['message', 'compose'], send[: 1])
  assert_equal('Me <me@example.org>', Flag(send, '--from'))
  assert_equal('Alice <a@example.org>', Flag(send, '--to'))
  assert_equal('"Doe, J." <j@example.org>', Flag(send, '--cc'))
  assert_equal('<none>', Flag(send, '--bcc'))
  assert_equal('Re: Réunion', Flag(send, '--subject'))
  assert_equal(file, Flag(send, '--attach'))
  assert_equal('<none>', Flag(send, '--posting-style'))
  assert_equal(['> hello', 'my answer'], readfile($'{$HIMALAYA_STUB_LOG}.body'))
enddef

def Test_reply_sends_unquoted_then_flags_the_source_answered()
  Reset()
  OpenListing()
  cursor(4, 1)
  compose.Reply()
  WaitFor(() => bufname() =~ 'Himalaya reply \[12\]', 'the reply buffer')

  compose.Send()
  WaitFor(() => !empty(CallWith('answered')), 'the answered flag')

  const send = CallWith('--send')
  assert_equal(['message', 'reply', '12'], send[: 2])
  assert_equal('none', Flag(send, '--posting-style'))
  assert_equal(['flag', 'add', '12', '--flag', 'answered'], CallWith('answered'))
enddef

def Test_edit_resumes_a_draft_with_its_attachments()
  Reset()
  OpenListing()
  cursor(5, 1)
  compose.Edit()
  WaitFor(() => &filetype == 'himalaya-email-writing', 'the resumed buffer')

  assert_equal('To: "Doe, J." <j@example.org>', getline(2))
  assert_equal('Subject: Draft', getline(5))
  assert_equal('draft body', getline(7))

  const attachments = copy(b:himalaya_compose.attachments)
  assert_equal(1, len(attachments))
  assert_true(filereadable(attachments[0]))

  compose.SaveDraft()
  WaitFor(() => !empty(CallWith('delete')), 'the original to be deleted')

  const save = CallWith('--save')
  assert_equal('drafts', Flag(save, '--save'))
  assert_equal('', Flag(save, '--signature'))
  assert_equal(attachments[0], Flag(save, '--attach'))
  assert_equal(['message', 'delete', '13'], CallWith('delete'))
  assert_false(isdirectory(fnamemodify(attachments[0], ':h')))
enddef

def Test_unknown_header_is_refused()
  Reset()
  compose.New()
  WaitFor(() => &filetype == 'himalaya-email-writing', 'the writing buffer')
  setline(2, 'X-Foo: bar')
  const count = len(Calls())

  compose.Send()
  sleep 100m

  assert_equal(count, len(Calls()))
  assert_match('Unsupported header `X-Foo`', execute('messages'))
enddef

const tests = [
  Test_listing_parses_ids_and_highlights_columns,
  Test_search_passes_the_query_as_one_argument,
  Test_failure_shows_the_stdout_error_and_the_logs,
  Test_compose_sends_headers_body_and_attachments_as_flags,
  Test_reply_sends_unquoted_then_flags_the_source_answered,
  Test_edit_resumes_a_draft_with_its_attachments,
  Test_unknown_header_is_refused,
]

var failed = 0
for Test in tests
  v:errors = []
  try
    Test()
  catch
    add(v:errors, $'{v:exception} at {v:throwpoint}')
  endtry
  const name = matchstr(string(Test), 'Test_\w\+')
  if empty(v:errors)
    writefile([$'ok {name}'], '/dev/stdout', 'a')
  else
    failed += 1
    writefile([$'FAIL {name}'] + v:errors, '/dev/stdout', 'a')
  endif
endfor

writefile([$'{len(tests) - failed} passed, {failed} failed'], '/dev/stdout', 'a')
execute failed == 0 ? 'qall!' : 'cquit!'
