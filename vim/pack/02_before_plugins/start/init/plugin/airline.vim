" force solarized theme
let g:airline_theme='solarized'
" enable tagline
let g:airline#extensions#tabline#enabled=1
" remove separator symbols
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_left_alt_sep=''
let g:airline_right_alt_sep=''
" use plain ascii symbols, unicode symbols don't look nice with every font
let g:airline_symbols_ascii=1
" show asyncrun status
let g:airline_section_error=airline#section#create_right(['%{g:asyncrun_status}'])
