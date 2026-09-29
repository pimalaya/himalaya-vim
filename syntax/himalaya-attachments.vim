vim9script

if exists('b:current_syntax')
  finish
endif

syntax match HimalayaAttachment /^.\+$/
highlight default link HimalayaAttachment Directory

b:current_syntax = 'himalaya-attachments'
