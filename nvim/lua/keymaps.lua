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

-- split navigation
vim.keymap.set({ 'n', 'i' }, '<C-Up>', function()
  vim.cmd.wincmd('k')
end, { desc = 'Go to up window' })
vim.keymap.set({ 'n', 'i' }, '<C-Down>', function()
  vim.cmd.wincmd('j')
end, { desc = 'Go to down window' })
vim.keymap.set({ 'n', 'i' }, '<C-Left>', function()
  vim.cmd.wincmd('h')
end, { desc = 'Go to left window' })
vim.keymap.set({ 'n', 'i' }, '<C-Right>', function()
  vim.cmd.wincmd('l')
end, { desc = 'Go to right window' })

-- visual shifting (does not exit visual mode)
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- gitsigns
local gitsigns = require('gitsigns')

vim.keymap.set('n', ']c', function()
  if vim.wo.diff then
    vim.cmd.normal { ']c', bang = true }
  else
    gitsigns.nav_hunk 'next'
  end
end, { desc = 'Jump to next git [c]hange' })

vim.keymap.set('n', '[c', function()
  if vim.wo.diff then
    vim.cmd.normal { '[c', bang = true }
  else
    gitsigns.nav_hunk 'prev'
  end
end, { desc = 'Jump to previous git [c]hange' })

vim.keymap.set('v', '<leader>gs', function()
  gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
end, { desc = '[s]stage hunk' })
vim.keymap.set('v', '<leader>gr', function()
  gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
end, { desc = '[r]eset hunk' })

vim.keymap.set('n', '<leader>gs', gitsigns.stage_hunk, { desc = '[s]tage hunk' })
vim.keymap.set('n', '<leader>gr', gitsigns.reset_hunk, { desc = '[r]eset hunk' })
vim.keymap.set('n', '<leader>gS', gitsigns.stage_buffer, { desc = '[S]tage buffer' })
vim.keymap.set('n', '<leader>gu', gitsigns.undo_stage_hunk, { desc = '[u]ndo stage hunk' })
vim.keymap.set('n', '<leader>gR', gitsigns.reset_buffer, { desc = '[R]eset buffer' })
vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk, { desc = '[p]review hunk' })
vim.keymap.set('n', '<leader>gb', gitsigns.blame_line, { desc = '[b]lame line' })
vim.keymap.set('n', '<leader>gd', gitsigns.diffthis, { desc = '[d]iff against index' })
vim.keymap.set('n', '<leader>gD', function()
  gitsigns.diffthis '@'
end, { desc = '[D]iff against last commit' })
vim.keymap.set('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'git [b]lame line' })
vim.keymap.set('n', '<leader>tD', gitsigns.toggle_deleted, { desc = 'git [D]eleted' })

-- nvim-tree
vim.keymap.set('n', '<leader>tt', require('nvim-tree.api').tree.toggle, { desc = 'nvim-[t]ree' })

-- telescope
local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sh', telescope_builtin.help_tags, { desc = '[s]earch [h]elp' })
vim.keymap.set('n', '<leader>sk', telescope_builtin.keymaps, { desc = '[s]earch [k]eymaps' })
vim.keymap.set('n', '<leader>sf', telescope_builtin.find_files, { desc = '[s]earch [f]iles' })
vim.keymap.set('n', '<leader>ss', telescope_builtin.builtin, { desc = '[s]earch [s]elect telescope' })
vim.keymap.set('n', '<leader>sw', telescope_builtin.grep_string, { desc = '[s]earch current [w]ord' })
vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, { desc = '[s]earch by [g]rep' })
vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, { desc = '[s]earch [d]iagnostics' })
vim.keymap.set('n', '<leader>sr', telescope_builtin.resume, { desc = '[s]earch [r]esume' })
vim.keymap.set('n', '<leader>s.', telescope_builtin.oldfiles, { desc = '[s]earch recent files ([.] for repeat)' })
vim.keymap.set('n', '<leader><leader>', telescope_builtin.buffers, { desc = '[ ] find existing buffers' })

-- lsp
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
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
