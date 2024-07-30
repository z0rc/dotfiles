vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '>-', trail = '·', extends = '►', precedes = '◄' }
vim.opt.backupdir:remove('.')
vim.opt.backup = true
vim.opt.undofile = true
vim.opt.swapfile = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.showmode = false

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

vim.lsp.set_log_level(vim.log.levels.OFF)
