" map spacebar as leader key
map <Space> <leader>

" if suggestions windows present, then <Enter> accepts selection
" else use pear-tree mapping
imap <expr> <CR> pumvisible() ? asyncomplete#close_popup() : '<Plug>(PearTreeExpand)'

" display search position like (2/10) for n/N commands
map n <Plug>(is-nohl)<Plug>(anzu-n-with-echo)
map N <Plug>(is-nohl)<Plug>(anzu-N-with-echo)

" git hunks navigation
nmap [c <Plug>GitGutterPrevHunk
nmap ]c <Plug>GitGutterNextHunk

" use alt+arrows to switch between splits and tmux panes
nnoremap <silent> <A-Left> :TmuxNavigateLeft<CR>
nnoremap <silent> <A-Down> :TmuxNavigateDown<CR>
nnoremap <silent> <A-Up> :TmuxNavigateUp<CR>
nnoremap <silent> <A-Right> :TmuxNavigateRight<CR>
nnoremap <silent> <A-\> :TmuxNavigatePrevious<CR>

" crtl+left/right to switch buffers in normal mode
nmap <C-Left> <Plug>AirlineSelectPrevTab
nmap <C-Right> <Plug>AirlineSelectNextTab

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

" I fat finger this too often. Command history window, you won't be missed
" Ctrl+f in command line in case you really need it
nnoremap q: :q

" allow saving of files as sudo when I forgot to start vim using sudo
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
