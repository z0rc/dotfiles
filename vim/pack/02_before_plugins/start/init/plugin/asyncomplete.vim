augroup asyncomple_vimrc
    autocmd!

    " register necovim source
    autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
        \ 'name': 'necovim',
        \ 'allowlist': ['vim'],
        \ 'completor': function('asyncomplete#sources#necovim#completor'),
        \ }))

    autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
        \ 'name': 'buffer',
        \ 'allowlist': ['*'],
        \ 'completor': function('asyncomplete#sources#buffer#completor'),
        \ 'config': {
        \    'max_buffer_size': 5000000,
        \    'clear_cache': 1,
        \    'min_word_len': 3,
        \  },
        \ }))

    " close complete popup when completion is done
    autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
augroup END

" show errors and warnings from lsp in statusline
let g:lsp_diagnostics_echo_cursor = 1

" enable references highlight
let g:lsp_highlight_references_enabled = 1

" enable symantic highlighting
let g:lsp_semantic_enabled = 1
