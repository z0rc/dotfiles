vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.title = true
vim.o.titlelen = 0
vim.o.titlestring = 'nvim: %{expand("%:p")}'
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.wrap = false
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '>-', trail = '·', extends = '▶', precedes = '◀', nbsp = '␣' }
vim.opt.backupdir:remove('.')
vim.o.backup = true
vim.o.undofile = true
vim.o.swapfile = true
vim.o.clipboard = 'unnamedplus'
vim.o.showmode = false
vim.o.inccommand = 'split'
vim.o.timeoutlen = 300
vim.o.updatetime = 800

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.fugitive_no_maps = 1

vim.lsp.set_log_level(vim.log.levels.OFF)
