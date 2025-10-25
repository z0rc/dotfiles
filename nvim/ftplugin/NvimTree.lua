-- toggle status-line of entering/leaving the nvim-tree
local tl_group = vim.api.nvim_create_augroup('toggle-laststatus', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  group = tl_group,
  buffer = 0,
  callback = function() vim.o.laststatus = 0 end,
})
vim.api.nvim_create_autocmd('BufLeave', {
  group = tl_group,
  buffer = 0,
  callback = function() vim.o.laststatus = 3 end,
})
