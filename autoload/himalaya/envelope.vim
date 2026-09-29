vim9script

import autoload 'himalaya/account.vim'
import autoload 'himalaya/cli.vim'
import autoload 'himalaya/mailbox.vim'

# The search query, empty to list the whole mailbox.
var query = ''

# Lines above the first envelope and below the last one: the top border,
# the header and its rule, then the bottom border.
const TABLE_CHROME = 4

# Opens the listing, after switching to the given account if any.
export def Open(name: string = '')
  if empty(name)
    List()
  else
    account.Set(name)
  endif
enddef

export def SetQuery()
  const text = input('Query: ', query)
  redraw
  Search(text)
enddef

# Searches the current mailbox from its first page, listing it all when
# the query is empty.
export def Search(text: string)
  query = trim(text)
  mailbox.Set(mailbox.Current(), mailbox.Label())
enddef

export def List()
  var args = account.Args() + ['envelope', empty(query) ? 'list' : 'search'] + mailbox.Args()
  args += ['--page', string(mailbox.Page())]
  args += ['--page-size', string(max([1, winheight(0) - TABLE_CHROME]))]
  args += ['--max-width', string(BufWidth())]

  if !empty(query)
    add(args, query)
  endif

  cli.Run(args, $'Listing {mailbox.Label()} envelopes', Render)
enddef

# Lists again, but only when a listing is shown.
export def Refresh()
  if ListingWindow() != 0
    List()
  endif
enddef

# The id of the envelope on the given line, empty outside of a row.
export def IdAt(lnum: number): string
  const id = matchstr(getline(lnum), '^[│┆|]\s*\zs[^│┆| ]\+')
  return id == 'ID' ? '' : id
enddef

export def Ids(first: number, last: number): list<string>
  return range(first, last)->map((_, lnum) => IdAt(lnum))->filter((_, id) => !empty(id))
enddef

def Render(out: string)
  const back = win_getid()
  const target = ListingWindow()
  if target != 0
    win_gotoid(target)
  endif

  const name = printf('Himalaya envelopes [%s] [%s] [page %d]',
    mailbox.Label(), empty(query) ? 'all' : query, mailbox.Page())

  if &filetype == 'himalaya-email-listing'
    execute 'silent keepalt file' fnameescape(name)
  else
    execute 'silent edit' fnameescape(name)
  endif

  setlocal modifiable
  silent :%delete _
  setline(1, split(out, "\n"))
  setlocal nomodifiable nomodified
  setlocal filetype=himalaya-email-listing
  cursor(FirstRow(), 1)

  if target != 0
    win_gotoid(back)
  endif
enddef

def ListingWindow(): number
  for buf in getbufinfo({bufloaded: true})
    if buf.name =~ 'Himalaya envelopes' && !empty(buf.windows)
      return buf.windows[0]
    endif
  endfor
  return 0
enddef

def FirstRow(): number
  for lnum in range(1, line('$'))
    if !empty(IdAt(lnum))
      return lnum
    endif
  endfor
  return 1
enddef

# The width available for text, without the number, fold and sign
# columns.
def BufWidth(): number
  var width = winwidth(0)

  if &number || &relativenumber
    width -= max([&numberwidth, strlen(string(line('$'))) + 1])
  endif

  width -= &foldcolumn

  if &signcolumn == 'yes' || (&signcolumn == 'auto' && !empty(sign_getplaced(bufnr())[0].signs))
    width -= 2
  endif

  return width
enddef
