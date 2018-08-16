let g:nerdtree_tabs_autofind=1

function! ToggleNERDTreeTabsFind()
    if g:NERDTree.IsOpen()
        NERDTreeTabsClose
    else
        NERDTreeTabsOpen
        wincmd w
        NERDTreeTabsFind
    endif
endfunction
