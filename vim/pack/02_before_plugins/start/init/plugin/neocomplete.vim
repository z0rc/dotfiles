" enable heavy omnicompletion patterns
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns={}
endif
let g:neocomplete#force_omni_input_patterns.python='\h\w*\|[^. \t]\.\w*'
let g:neocomplete#force_omni_input_patterns.ruby='[^. *\t]\.\w*\|\h\w*::'
let g:neocomplete#force_omni_input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#force_omni_input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
let g:neocomplete#force_omni_input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" completion tuning
let g:neocomplete#enable_at_startup=1
let g:neocomplete#enable_smart_case=1
let g:neocomplete#min_keyword_length=3
let g:necosyntax#min_keyword_length=3
