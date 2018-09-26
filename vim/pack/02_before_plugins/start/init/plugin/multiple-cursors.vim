" disable deoplete when using multiple cursors
function g:Multiple_cursors_before()
  call deoplete#disable()
endfunction
function g:Multiple_cursors_after()
  call deoplete#enable()
endfunction
