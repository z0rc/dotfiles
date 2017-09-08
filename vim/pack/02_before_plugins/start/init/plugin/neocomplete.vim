setlocal omnifunc=syntaxcomplete#Complete

" enable omnicompletion for python and ruby
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns={}
endif
let g:neocomplete#force_omni_input_patterns.python='\h\w*\|[^. \t]\.\w*'
let g:neocomplete#force_omni_input_patterns.ruby='[^. *\t]\.\w*\|\h\w*::'

" completion tuning
let g:neocomplete#enable_at_startup=1
let g:neocomplete#enable_smart_case=1
let g:neocomplete#min_keyword_length=3
let g:necosyntax#min_keyword_length=3
let g:neocomplete#sources = {}
let g:neocomplete#sources._ = ['file', 'omni', 'buffer', 'syntax']
let g:neocomplete#sources.vim = g:neocomplete#sources._ + ['vim']
