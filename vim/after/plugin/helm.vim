" vim-helm sets commentstring from a FileType autocmd, which runs after
" ftplugins, so override it from here to win the ordering
augroup helm_commentstring
    autocmd!
    autocmd FileType helm setlocal commentstring=#\ %s
augroup END
