" enable support of more colors
if has('termguicolors')
 set termguicolors
  " hack to make tmux work with termguicolors
  if ! empty($TMUX)
    set t_8f=[38;2;%lu;%lu;%lum
    set t_8b=[48;2;%lu;%lu;%lum
  endif
endif

set background=dark
colorscheme solarized8_flat
