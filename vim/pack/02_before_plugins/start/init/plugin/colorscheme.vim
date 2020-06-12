" enable support of more colors
if has('termguicolors')
    set termguicolors
    let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
endif

set background=dark
colorscheme solarized8_flat
