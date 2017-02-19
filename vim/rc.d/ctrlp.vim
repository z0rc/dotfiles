" enable ctrlp py matcher if python is present
if has('python') || has('python3')
  let g:ctrlp_match_func={ 'match': 'pymatcher#PyMatch' }
endif

" set delay to prevent extra search
let g:ctrlp_lazy_update=350

" do not clear filenames cache, to improve CtrlP startup
" manualy clear it by <F5>
let g:ctrlp_clear_cache_on_exit=0

" set no file limit, we are building a big project
let g:ctrlp_max_files=0

" if ag is available use it as filename list generator instead of 'find'
if executable("ag")
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command='ag %s -i --nocolor --nogroup --ignore ''.git'' --ignore ''.DS_Store'' --ignore ''node_modules'' --hidden -g ""'
endif
