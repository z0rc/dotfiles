-- sanity https://github.com/neovim/neovim/issues/9953#issuecomment-1732700161
vim.keymap.set('c', '<Up>', function()
  return vim.fn.wildmenumode() == 1 and '<Left>' or '<Up>'
end, { expr = true })
vim.keymap.set('c', '<Down>', function()
  return vim.fn.wildmenumode() == 1 and '<Right>' or '<Down>'
end, { expr = true })
vim.keymap.set('c', '<Left>', function()
  return vim.fn.wildmenumode() == 1 and '<Up>' or '<Left>'
end, { expr = true })
vim.keymap.set('c', '<Right>', function()
  return vim.fn.wildmenumode() == 1 and '<Down>' or '<Right>'
end, { expr = true })

-- tmux/split navigation
local tmux = require('tmux')
vim.keymap.set({ 'n', 'i' }, '<S-Up>', tmux.move_top, { desc = 'Go to up pane' })
vim.keymap.set({ 'n', 'i' }, '<S-Down>', tmux.move_bottom, { desc = 'Go to down pane' })
vim.keymap.set({ 'n', 'i' }, '<S-Left>', tmux.move_left, { desc = 'Go to left pane' })
vim.keymap.set({ 'n', 'i' }, '<S-Right>', tmux.move_right, { desc = 'Go to right pane' })

-- visual shifting (does not exit visual mode)
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- duplicate and comment
vim.keymap.set('n', 'ycc', function()
  return 'yy' .. vim.v.count1 .. "gcc']p"
end, { remap = true, expr = true, desc = 'Duplicate and comment lines' })

-- nvim-tree
vim.keymap.set('n', '<leader>tt', require('nvim-tree.api').tree.toggle, { desc = 'nvim-[t]ree' })

-- telescope
local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, { desc = '[h]elp' })
vim.keymap.set('n', '<leader>fk', telescope_builtin.keymaps, { desc = '[k]eymaps' })
vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, { desc = '[f]iles' })
vim.keymap.set('n', '<leader>fs', telescope_builtin.builtin, { desc = '[s]elect telescope' })
vim.keymap.set('n', '<leader>fw', telescope_builtin.grep_string, { desc = 'current [w]ord' })
vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, { desc = '[g]rep' })
vim.keymap.set('n', '<leader>fd', telescope_builtin.diagnostics, { desc = '[d]iagnostics' })
vim.keymap.set('n', '<leader>fr', telescope_builtin.resume, { desc = '[r]esume' })
vim.keymap.set('n', '<leader>f.', telescope_builtin.oldfiles, { desc = 'recent files ([.] for repeat)' })
vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, { desc = '[b]uffers' })
vim.keymap.set('n', '<leader>fn', require('telescope').extensions.fidget.fidget, { desc = '[n]otification' })
vim.keymap.set('n', '<leader>fp', require('telescope').extensions.project.project, { desc = '[p]rojects' })
vim.keymap.set('n', '<leader>fy', require('telescope').extensions.schema_companion.select_schema,
  { desc = '[y]aml schema' })
vim.keymap.set('n', '<leader>fc', require('telescope').extensions.codecompanion.codecompanion,
  { desc = '[c]odecompanion actions' })

-- lsp
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP keymap actions',
  group = vim.api.nvim_create_augroup('lsp-attach-keymap', { clear = true }),
  callback = function(event)
    vim.keymap.set('n', '<leader>li', vim.lsp.buf.hover, { buffer = event.buf, desc = 'symbol [i]nformation hover' })
    vim.keymap.set('n', '<leader>ld', telescope_builtin.lsp_definitions,
      { buffer = event.buf, desc = 'goto [d]efinition' })
    vim.keymap.set('n', '<leader>lm', telescope_builtin.lsp_implementations,
      { buffer = event.buf, desc = 'goto i[m]plementation' })
    vim.keymap.set('n', '<leader>lt', telescope_builtin.lsp_type_definitions,
      { buffer = event.buf, desc = 'goto [t]ype definition' })
    vim.keymap.set('n', '<leader>lr', telescope_builtin.lsp_references,
      { buffer = event.buf, desc = 'list [r]eferences' })
    vim.keymap.set('n', '<leader>ls', vim.lsp.buf.signature_help, { buffer = event.buf, desc = '[s]iganture help' })
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { buffer = event.buf, desc = '[r]ename symbol' })
    vim.keymap.set({ 'n', 'x' }, '<leader>lf', vim.lsp.buf.format,
      { buffer = event.buf, desc = '[f]ormat buffer' })
    vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { buffer = event.buf, desc = 'code [a]ction' })
  end,
})

-- markview
vim.keymap.set('n', '<leader>tm', require('markview').commands.toggle, { desc = '[m]arkdown rendering' })

-- codecompanion
vim.keymap.set('n', '<leader>tc', require('codecompanion').toggle, { desc = '[c]odecompanion chat' })

-- mini.diff
vim.keymap.set('n', '<leader>td', require('mini.diff').toggle_overlay, { desc = '[d]iff overlay' })
