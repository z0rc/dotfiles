vim.g.mapleader = ' '

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

-- split navigation
vim.keymap.set({'n', 'i'}, '<C-Up>', function()
  vim.cmd.wincmd('k')
end)
vim.keymap.set({'n', 'i'}, '<C-Down>', function()
  vim.cmd.wincmd('j')
end)
vim.keymap.set({'n', 'i'}, '<C-Left>', function()
  vim.cmd.wincmd('h')
end)
vim.keymap.set({'n', 'i'}, '<C-Right>', function()
  vim.cmd.wincmd('l')
end)

-- visual shifting (does not exit visual mode)
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')
