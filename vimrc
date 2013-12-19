call pathogen#infect()

syntax on
set background=dark
let g:solarized_termtrans=1
let g:solarized_termcolors=256
let g:solarized_underline=0
set t_Co=256
colorscheme solarized

set filetype=on
set shiftround
set showmatch " show matching brackets when text indicator is over them
set expandtab " use spaces instead of tabs
set smarttab " be smart when using tabs
set shiftwidth=4 " 1 tab == 4 spaces
set tabstop=4
set shiftwidth=4 ai
set history=150 " keep 150 lines of command line history
set showcmd " display incomplete commands
set incsearch " do incremental searching
set hlsearch " highlight search results
set ignorecase " ignore case when searching
set smartcase " when searching try to be smart about cases
set fileencodings=utf-8,cp1251,koi-8r,cp866
set fileformats=unix,dos
set nowrap
set ttyfast
set clipboard=unnamedplus

set mouse=a

nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

set listchars=tab:<-,trail:.
set list

set number
nnoremap <F3> :NumbersToggle<CR>
nnoremap <F4> :NumbersOnOff<CR>
set cursorline
set ruler " always show current position

" Change cursor shape in different modes
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

set foldenable
set foldmethod=manual
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

set wildmenu

autocmd BufRead,BufNewFile /etc/nginx/*,/etc/nginx/*/* setfiletype nginx

filetype plugin indent on
set ai " auto indent
set si " smart indent

autocmd vimenter * if !argc() | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Mode Indication -Prominent!
function! InsertStatuslineColor(mode)
    if a:mode == 'i'
        hi statusline ctermbg=red
        set cursorcolumn
    elseif a:mode == 'r'
        hi statusline ctermbg=blue
    else
        hi statusline ctermbg=magenta
    endif
endfunction

function! InsertLeaveActions()
    hi statusline ctermbg=green ctermfg=black
    set nocursorcolumn
endfunction

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * call InsertLeaveActions()

" to handle exiting insert mode via a control-C
inoremap <c-c> <c-o>:call InsertLeaveActions()<cr><c-c>

" default the statusline to green when entering
hi statusline ctermbg=green ctermfg=black
set statusline=%t\ %y%m%r[%{&fileencoding}]%<[%{strftime(\"%d.%m.%y\",getftime(expand(\"%:p\")))}]%{fugitive#statusline()}%k%=%-14.(%l,%c%V%)\ %P
set laststatus=2
set modeline

set clipboard+=unnamed

" Allow saving of files as sudo when I forgot to start vim using sudo
cmap w!! %!sudo tee > /dev/null %

