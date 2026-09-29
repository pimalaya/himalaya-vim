vim9script

if exists('b:current_syntax')
  finish
endif

runtime! syntax/mail.vim

b:current_syntax = 'himalaya-email-reading'
