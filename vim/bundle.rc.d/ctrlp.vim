" enable ctrlp py matcher if python is present
if has('python')
    let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
endif
