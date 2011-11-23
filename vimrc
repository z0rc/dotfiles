set hlsearch

set listchars=tab:<-,trail:.
set list

set number
set cursorline
set cursorcolumn

set foldenable
set foldmethod=manual
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

set wildmenu

set statusline=%t\ %y%m%r[%{&fileencoding}]%<[%{strftime(\"%d.%m.%y\",getftime(expand(\"%:p\")))}]%k%=%-14.(%l,%c%V%)\ %P
set laststatus=2

set clipboard+=unnamed

