autocmd CmdlineEnter * ++once call s:wilder_init() | call wilder#main#start()

function! s:wilder_init() abort
  call wilder#setup({'modes': [':']})
  call wilder#set_option('renderer', wilder#wildmenu_renderer({
    \ 'highlighter': wilder#basic_highlighter(),
    \ 'separator': ' · ',
    \ }))
endfunction
