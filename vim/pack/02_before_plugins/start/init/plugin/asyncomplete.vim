augroup asyncomple_vimrc
    autocmd!

    " register necovim source
    autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
    \   'name': 'necovim',
    \   'allowlist': ['vim'],
    \   'completor': function('asyncomplete#sources#necovim#completor'),
    \ }))

    autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \   'name': 'buffer',
    \   'allowlist': ['*'],
    \   'completor': function('asyncomplete#sources#buffer#completor'),
    \   'config': {
    \       'max_buffer_size': 5000000,
    \       'clear_cache': 1,
    \       'min_word_len': 3,
    \   },
    \ }))

    " close complete popup when completion is done
    autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
augroup END

" preprocessor to remove duplicates and sort by priority
function! s:my_asyncomplete_preprocessor(options, matches) abort
    let l:dict = {}
    for [l:source_name, l:matches] in items(a:matches)
        let l:source_priority = get(asyncomplete#get_source_info(l:source_name),'priority',0)
        for l:item in l:matches['items']
            if stridx(l:item['word'], a:options['base']) == 0
                let l:item['priority'] = l:source_priority
                if has_key(l:dict,l:item['word'])
                    let l:old_item = get(l:dict, l:item['word'])
                    if l:old_item['priority'] <  l:source_priority
                        let l:dict[item['word']] = l:item
                    endif
                else
                    let l:dict[item['word']] = l:item
                endif
            endif
        endfor
    endfor
    let l:items =  sort(values(l:dict),{a, b -> b['priority'] - a['priority']})
    call asyncomplete#preprocess_complete(a:options, l:items)
endfunction

let g:asyncomplete_preprocessor = [function('s:my_asyncomplete_preprocessor')]

" show errors and warnings from lsp in statusline
let g:lsp_diagnostics_echo_cursor = 1

" enable references highlight
let g:lsp_highlight_references_enabled = 1

" enable symantic highlighting
let g:lsp_semantic_enabled = 1
