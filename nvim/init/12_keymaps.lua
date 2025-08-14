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

-- telescope
local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, { desc = 'Help' })
vim.keymap.set('n', '<leader>fk', telescope_builtin.keymaps, { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, { desc = 'Files' })
vim.keymap.set('n', '<leader>fs', telescope_builtin.builtin, { desc = 'Select telescope' })
vim.keymap.set('n', '<leader>fw', telescope_builtin.grep_string, { desc = 'Current word' })
vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, { desc = 'Grep' })
vim.keymap.set('n', '<leader>fd', telescope_builtin.diagnostics, { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>fr', telescope_builtin.resume, { desc = 'Resume' })
vim.keymap.set('n', '<leader>fo', telescope_builtin.oldfiles, { desc = 'Recent old files' })
vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fn', require('telescope').extensions.fidget.fidget, { desc = 'Notifications' })
vim.keymap.set('n', '<leader>fp', require('telescope').extensions.project.project, { desc = 'Projects' })
vim.keymap.set('n', '<leader>fy', require('telescope').extensions.schema_companion.select_schema,
  { desc = 'YAML schema' })
vim.keymap.set('n', '<leader>fc', require('telescope').extensions.codecompanion.codecompanion,
  { desc = 'CodeCompanion actions' })

-- lsp
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP keymap actions',
  group = vim.api.nvim_create_augroup('lsp-attach-keymap', { clear = true }),
  callback = function(event)
    vim.keymap.set('n', '<leader>li', vim.lsp.buf.hover, { buffer = event.buf, desc = 'Symbol information hover' })
    vim.keymap.set('n', '<leader>ld', telescope_builtin.lsp_definitions, { buffer = event.buf, desc = 'Goto definition' })
    vim.keymap.set('n', '<leader>lm', telescope_builtin.lsp_implementations,
      { buffer = event.buf, desc = 'Goto implementation' })
    vim.keymap.set('n', '<leader>lt', telescope_builtin.lsp_type_definitions,
      { buffer = event.buf, desc = 'Goto type definition' })
    vim.keymap.set('n', '<leader>lr', telescope_builtin.lsp_references, { buffer = event.buf, desc = 'List references' })
    vim.keymap.set('n', '<leader>ls', vim.lsp.buf.signature_help, { buffer = event.buf, desc = 'Signature help' })
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { buffer = event.buf, desc = 'Rename symbol' })
    vim.keymap.set({ 'n', 'x' }, '<leader>lf', vim.lsp.buf.format, { buffer = event.buf, desc = 'Format buffer' })
    vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { buffer = event.buf, desc = 'Code action' })
  end,
})

-- toggles
vim.keymap.set('n', '<leader>tt', require('nvim-tree.api').tree.toggle, { desc = 'NvimTree' })
vim.keymap.set('n', '<leader>tm', require('markview').commands.toggle, { desc = 'Markdown rendering' })
vim.keymap.set('n', '<leader>tc', require('codecompanion').toggle, { desc = 'CodeCompanion chat' })
vim.keymap.set('n', '<leader>td', require('mini.diff').toggle_overlay, { desc = 'Diff overlay' })
