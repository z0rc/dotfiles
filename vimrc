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
set shiftwidth=4 ai
set showmatch
set softtabstop=4
set tabstop=4
set history=150 " keep 150 lines of command line history
set showcmd " display incomplete commands
set incsearch " do incremental searching
set fileencodings=utf-8,cp1251,koi-8r,cp866
set fileformats=unix,dos
set nowrap
set ttyfast

nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

set hlsearch

set listchars=tab:<-,trail:.
set list

set number
nnoremap <F3> :NumbersToggle<CR>
nnoremap <F4> :NumbersOnOff<CR>
set cursorline
set ruler

set foldenable
set foldmethod=manual
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

set wildmenu

filetype plugin indent on

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
set statusline=%t\ %y%m%r[%{&fileencoding}]%<[%{strftime(\"%d.%m.%y\",getftime(expand(\"%:p\")))}]%k%=%-14.(%l,%c%V%)\ %P
set laststatus=2
set modeline

set clipboard+=unnamed

" Allow saving of files as sudo when I forgot to start vim using sudo
cmap w!! %!sudo tee > /dev/null %

