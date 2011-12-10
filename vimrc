colorscheme solarized

set hlsearch

set listchars=tab:<-,trail:.
set list

set number
set cursorline

set foldenable
set foldmethod=manual
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

set wildmenu

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

set clipboard+=unnamed

" Allow saving of files as sudo when I forgot to start vim using sudo
cmap w!! %!sudo tee > /dev/null %
