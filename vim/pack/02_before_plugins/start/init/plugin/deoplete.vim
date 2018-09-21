" completion tuning
let g:deoplete#enable_yarp=1
let g:deoplete#enable_smart_case=1
let g:necosyntax#min_keyword_length=2

" enable terrafrom omnicompletion
let g:deoplete#omni_patterns={}
let g:deoplete#omni_patterns.terraform='[^ *\t"{=$]\w*'

" load deoplete on switching to insert mode
let g:deoplete#enable_at_startup=0
augroup deoplete_init
  autocmd!
  autocmd InsertEnter * call deoplete#enable()
augroup END
