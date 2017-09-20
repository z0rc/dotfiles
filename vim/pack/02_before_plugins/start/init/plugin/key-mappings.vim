" if suggestions windows present, then <Enter> accepts selection
" else use AutoPairs mapping
imap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>\<Plug>AutoPairsReturn"

" <TAB>: expand neosnippets
imap <expr> <TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand)" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char
imap <expr> <C-h> neocomplete#smart_close_popup()."\<C-h>"
imap <expr> <BS> neocomplete#smart_close_popup()."\<C-h>"

" replace default search with incsearch
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)<Paste>
" incsearch with easymotion across results
map z/ <Plug>(incsearch-easymotion-/)
map z? <Plug>(incsearch-easymotion-?)
map zg/ <Plug>(incsearch-easymotion-stay)

" use ctrl+arrows to switch between splits and tmux panes
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

" git hunks navigation
nmap [c <Plug>GitGutterPrevHunk
nmap ]c <Plug>GitGutterNextHunk

" alt+left/right to switch buffers
map <A-left> :bprev!<CR>
map <A-right> :bnext!<CR>
map [1;9C :bnext!<CR>
map [1;9D :bprev!<CR>
map <ESC>b :bprev!<CR>
map <ESC>f :bnext!<CR>

" ctrl+o to search through command palette
nnoremap <C-o> :CtrlPCmdPalette<CR>
inoremap <C-o> <ESC>:CtrlPCmdPalette<CR>

" visual shifting (does not exit visual mode)
vnoremap < <gv
vnoremap > >gv

" accept commands with accidential shift key pressed
command! -bang -nargs=* -complete=file E e<bang> <args>
command! -bang -nargs=* -complete=file W w<bang> <args>
command! -bang -nargs=* -complete=file Wq wq<bang> <args>
command! -bang -nargs=* -complete=file WQ wq<bang> <args>
command! -bang Wa wa<bang>
command! -bang WA wa<bang>
command! -bang Q q<bang>
command! -bang QA qa<bang>
command! -bang Qa qa<bang>

" allow the . to execute once for each line of a visual selection
vnoremap . :normal .<CR>

" allow saving of files as sudo when I forgot to start vim using sudo
cmap w!! !sudo tee % > /dev/null
