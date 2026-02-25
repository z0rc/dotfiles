vim.loader.enable()

vim.o.title = true
vim.o.titlelen = 0
vim.o.titlestring = 'nvim: %{substitute(expand("%:p"), $HOME, "~", "")}'
vim.o.colorcolumn = '+1'
vim.o.laststatus = 3
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.autoindent = true
vim.o.breakindentopt = 'list:-1'
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.switchbuf = 'usetab'
vim.o.confirm = true
vim.o.exrc = true
vim.o.foldlevel = 20
vim.o.foldtext = ''
vim.o.spelloptions = 'camel'
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]
vim.o.iskeyword = '@,48-57,_,192-255,-'

vim.opt.backupdir:remove('.')

vim.o.keymap = 'ukrainian-enhanced'
vim.o.iminsert = 0
vim.o.imsearch = 0

-- https://github.com/nvim-lua/kickstart.nvim/pull/1049
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
  if vim.env.SSH_TTY then vim.g.clipboard = 'osc52' end
end)

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.lsp.set_log_level(vim.log.levels.OFF)
vim.diagnostic.config({
  severity_sort = true,
  virtual_text = { source = 'if_many' },
})
