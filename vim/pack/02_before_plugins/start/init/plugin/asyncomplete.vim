augroup asyncomple_vimrc
    autocmd!

    " register neoinclude
    autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#neoinclude#get_source_options({
        \ 'name': 'neoinclude',
        \ 'whitelist': ['cpp'],
        \ 'refresh_pattern': '\(<\|"\|/\)$',
        \ 'completor': function('asyncomplete#sources#neoinclude#completor'),
        \ }))

    " register necovim
    autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
        \ 'name': 'necovim',
        \ 'whitelist': ['vim'],
        \ 'completor': function('asyncomplete#sources#necovim#completor'),
        \ }))

    " close complete popup when completion is done
    autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
augroup END

" show errors and warnings from lsp in statusline
let g:lsp_diagnostics_echo_cursor = 1

" enable references highlight
let g:lsp_highlight_references_enabled = 1
