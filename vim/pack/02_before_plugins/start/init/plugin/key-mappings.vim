" map spacebar as leader key
map <Space> <leader>

" if suggestions windows present, then <Enter> accepts selection
" else use delimitMateCR mapping
imap <expr> <CR> pumvisible() ? asyncomplete#close_popup() : '<Plug>delimitMateCR'

" git hunks navigation
nmap [c <Plug>GitGutterPrevHunk
nmap ]c <Plug>GitGutterNextHunk

" split navigation
nnoremap <silent> <C-Up> :wincmd k<CR>
nnoremap <silent> <C-Down> :wincmd j<CR>
nnoremap <silent> <C-Left> :wincmd h<CR>
nnoremap <silent> <C-Right> :wincmd l<CR>
inoremap <silent> <C-Up> <Esc>:wincmd k<CR>
inoremap <silent> <C-Down> <Esc>:wincmd j<CR>
inoremap <silent> <C-Left> <Esc>:wincmd h<CR>
inoremap <silent> <C-Right> <Esc>:wincmd l<CR>

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
