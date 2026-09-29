vim9script

import autoload 'himalaya/account.vim'
import autoload 'himalaya/cli.vim'
import autoload 'himalaya/envelope.vim'
import autoload 'himalaya/picker.vim'

# The selected mailbox id, empty for the default one of the CLI config.
var current = ''
var label = ''
var page = 1

export def Current(): string
  return current
enddef

export def Label(): string
  return empty(current) ? 'default' : label
enddef

export def Page(): number
  return page
enddef

# The CLI arguments selecting the current mailbox.
export def Args(): list<string>
  return empty(current) ? [] : ['--mailbox', current]
enddef

# Lets the user pick a mailbox of the current account, then calls
# OnSelect with its id.
export def Pick(OnSelect: func(string, string))
  cli.Json(account.Args() + ['mailbox', 'list'], 'Listing mailboxes', (data) => {
    var ids = {}
    for mbox in data.mailboxes
      ids[mbox.name] = mbox.id
    endfor
    picker.Pick('mailbox', keys(ids)->sort(), (name) => {
      OnSelect(ids[name], name)
    })
  })
enddef

export def Select()
  Pick(Set)
enddef

export def Set(id: string, name: string = id)
  current = id
  label = name
  page = 1
  envelope.List()
enddef

export def Reset()
  Set('')
enddef

export def NextPage()
  page += 1
  envelope.List()
enddef

export def PreviousPage()
  page = max([1, page - 1])
  envelope.List()
enddef
