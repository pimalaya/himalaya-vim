vim9script

import autoload 'himalaya/cli.vim'
import autoload 'himalaya/mailbox.vim'
import autoload 'himalaya/picker.vim'

# The selected account, empty for the default one of the CLI config.
var current = ''

export def Current(): string
  return current
enddef

# The CLI arguments selecting the current account.
export def Args(): list<string>
  return empty(current) ? [] : ['--account', current]
enddef

export def Select()
  cli.Json(['account', 'list'], 'Listing accounts', (data) => {
    picker.Pick('account', mapnew(data.accounts, (_, account) => account.name), Set)
  })
enddef

export def Set(name: string)
  current = name
  mailbox.Reset()
enddef
