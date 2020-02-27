" register neoinclude
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#neoinclude#get_source_options({
    \ 'name': 'neoinclude',
    \ 'whitelist': ['cpp'],
    \ 'refresh_pattern': '\(<\|"\|/\)$',
    \ 'completor': function('asyncomplete#sources#neoinclude#completor'),
    \ }))

" register necosyntax
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necosyntax#get_source_options({
    \ 'name': 'necosyntax',
    \ 'whitelist': ['*'],
    \ 'completor': function('asyncomplete#sources#necosyntax#completor'),
    \ }))

" register necovim
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
    \ 'name': 'necovim',
    \ 'whitelist': ['vim'],
    \ 'completor': function('asyncomplete#sources#necovim#completor'),
    \ }))

" filter out from completion syntax definitions added by rainbow plugin (colored parentheses)
let g:asyncomplete_preprocessor = [function('asyncomplete#preprocessor#ezfilter#filter')]
let g:asyncomplete#preprocessor#ezfilter#config = {}
let g:asyncomplete#preprocessor#ezfilter#config.necosyntax = {ctx, items -> filter(items, 'v:val.word !~ "Rainbow"')}

" close complete popup when completion is done
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" show errors and warnings from lsp in statusline
let g:lsp_diagnostics_echo_cursor = 1
