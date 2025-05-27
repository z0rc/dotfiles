vim.bo.expandtab = false

vim.treesitter.start()
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
