augroup asyncomple_vimrc
    autocmd!

    " register necovim source
    autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
        \ 'name': 'necovim',
        \ 'whitelist': ['vim'],
        \ 'completor': function('asyncomplete#sources#necovim#completor'),
        \ }))

    " register omni source
    autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
        \ 'name': 'omni',
        \ 'whitelist': ['zsh'],
        \ 'completor': function('asyncomplete#sources#omni#completor'),
        \ }))

    " register tags source
    autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
        \ 'name': 'tags',
        \ 'whitelist': ['*'],
        \ 'blacklist': ['terraform', 'python'],
        \ 'completor': function('asyncomplete#sources#tags#completor'),
        \ }))

    " close complete popup when completion is done
    autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
augroup END

" show errors and warnings from lsp in statusline
let g:lsp_diagnostics_echo_cursor = 1

" enable references highlight
let g:lsp_highlight_references_enabled = 1
