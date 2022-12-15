call wilder#setup({'modes': [':', '?']})

call wilder#set_option('renderer', wilder#wildmenu_renderer(
  \ wilder#wildmenu_airline_theme({
  \   'highlighter': wilder#basic_highlighter(),
  \ })))
