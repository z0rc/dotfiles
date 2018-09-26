" completion tuning
let g:deoplete#enable_yarp=1
let g:deoplete#enable_smart_case=1
let g:necosyntax#min_keyword_length=2

call deoplete#custom#var('omni', 'input_patterns', {
  \ 'ruby': ['[^. *\t]\.\w*', '[a-zA-Z_]\w*::'],
  \ 'terraform': '[^ *\t"{=$]\w*'
  \})

call deoplete#custom#option('keyword_patterns', {
  \ 'ruby': '[a-zA-Z_]\w*[!?]?'
  \})

call deoplete#custom#source('omni', 'functions', {
  \ 'ruby': 'rubycomplete#Complete',
  \ 'terraform': 'terraformcomplete#Complete'
  \})

" load deoplete on switching to insert mode
let g:deoplete#enable_at_startup=0
augroup deoplete_init
  autocmd!
  autocmd InsertEnter * call deoplete#enable()
augroup END
