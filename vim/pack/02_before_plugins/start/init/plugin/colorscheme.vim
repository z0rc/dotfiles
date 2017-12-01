" check for WSL
let kernel_version=system('uname -v')

" enable modern colors if supported
set background=dark
if has('termguicolors') && $TERM_PROGRAM !=# 'Apple_Terminal' && kernel_version !~ 'Microsoft'
  " hack to make tmux work with termguicolors
  if ! empty($TMUX)
    set t_8f=[38;2;%lu;%lu;%lum
    set t_8b=[48;2;%lu;%lu;%lum
  endif
  set termguicolors
  colorscheme solarized8_dark_flat
else
  let g:solarized_termtrans=1
  let g:solarized_termcolors=256
  let g:solarized_underline=0
  colorscheme solarized
endif
