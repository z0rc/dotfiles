" enable tagline and remove separator symbols
let g:airline#extensions#tabline#enabled=1
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_left_alt_sep=''
let g:airline_right_alt_sep=''

" show asyncrun status
let g:airline_section_error = airline#section#create_right(['%{g:asyncrun_status}'])
