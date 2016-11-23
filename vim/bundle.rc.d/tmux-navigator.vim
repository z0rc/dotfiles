" disable default tmux nav mappings
let g:tmux_navigator_no_mappings=1
" user ctrl+arrows to switch between splits and tmux panes
nnoremap <silent> <C-Left> :TmuxNavigateLeft<CR>
inoremap <silent> <C-Left> <ESC>:TmuxNavigateLeft<CR>
nnoremap <silent> <C-Down> :TmuxNavigateDown<CR>
inoremap <silent> <C-Down> <ESC>:TmuxNavigateDown<CR>
nnoremap <silent> <C-Up> :TmuxNavigateUp<CR>
inoremap <silent> <C-Up> <ESC>:TmuxNavigateUp<CR>
nnoremap <silent> <C-Right> :TmuxNavigateRight<CR>
inoremap <silent> <C-Right> <ESC>:TmuxNavigateRight<CR>
nnoremap <silent> <C-\> :TmuxNavigatePrevious<CR>
inoremap <silent> <C-\> <ESC>:TmuxNavigatePrevious<CR>
