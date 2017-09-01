" Enable modern colors if supported
set background=dark
if has('termguicolors') && $TERM_PROGRAM !=# 'Apple_Terminal' && empty($TMUX)
  set termguicolors
  colorscheme solarized8_dark_flat
else
  let g:solarized_termtrans=1
  let g:solarized_termcolors=256
  let g:solarized_underline=0
  colorscheme solarized
endif
