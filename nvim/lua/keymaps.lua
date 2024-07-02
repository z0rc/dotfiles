-- sanity https://github.com/neovim/neovim/issues/9953#issuecomment-1732700161
vim.keymap.set('c', '<Up>', function()
  return vim.fn.wildmenumode() == 1 and '<Left>' or '<Up>'
end, {expr = true})
vim.keymap.set('c', '<Down>', function()
  return vim.fn.wildmenumode() == 1 and '<Right>' or '<Down>'
end, {expr = true})
vim.keymap.set('c', '<Left>', function()
  return vim.fn.wildmenumode() == 1 and '<Up>' or '<Left>'
end, {expr = true})
vim.keymap.set('c', '<Right>', function()
  return vim.fn.wildmenumode() == 1 and '<Down>' or '<Right>'
end, {expr = true})
