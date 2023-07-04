autocmd CmdlineEnter * ++once call s:wilder_init() | call wilder#main#start()

function! s:wilder_init() abort
    call wilder#setup({'modes': [':']})
    call wilder#set_option('pipeline', [
    \   wilder#branch(
    \       wilder#cmdline_pipeline({
    \           'hide_in_substitute': 1,
    \           'debounce': 100,
    \       }),
    \   ),
    \ ])
    call wilder#set_option('renderer', wilder#popupmenu_renderer({
    \   'highlighter': wilder#basic_highlighter(),
    \ }))
endfunction
