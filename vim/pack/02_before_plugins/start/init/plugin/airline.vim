" force solarized theme
let g:airline_theme='solarized'
" don't show expected encoding
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
" remove separator symbols
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_left_alt_sep=''
let g:airline_right_alt_sep=''
" use plain ascii symbols, unicode symbols don't look nice with every font
let g:airline_symbols_ascii=1
