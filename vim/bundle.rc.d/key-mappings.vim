" recommended key-mappings for completion
" <CR>: close popup and save indent
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: supertab like neosnippet expand
imap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ? "\<C-n>" : "\<TAB>")
smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
imap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""
smap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""
" <C-h>, <BS>: close popup and delete backword char
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

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
nnoremap <A-left> :bprev!<CR>
inoremap <A-left> <ESC>:bprev!<CR>
nnoremap <A-right> :bnext!<CR>
inoremap <A-right> <ESC>:bnext!<CR>

" use space to toggle folding
nnoremap <Space> za
vnoremap <Space> zf

" ctrl+o to search through command palette
nnoremap <C-o> :CtrlPCmdPalette<CR>
inoremap <C-o> <ESC>:CtrlPCmdPalette<CR>

" allow saving of files as sudo when I forgot to start vim using sudo
cmap w!! %!sudo tee > /dev/null %
