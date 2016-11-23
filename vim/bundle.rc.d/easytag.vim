" automatic tags creation tuning
let g:easytags_async=1
if has('nvim')
    let g:easytags_file=$XDG_CACHE_HOME . '/nvim/tags'
else
    let g:easytags_file=$XDG_CACHE_HOME . '/vim/tags'
endif
let g:easytags_suppress_ctags_warning=1
let b:easytags_auto_highlight=0
let g:easytags_python_enabled=1
