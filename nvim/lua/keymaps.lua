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
end, { desc = 'go to up window' })
vim.keymap.set({ 'n', 'i' }, '<C-Down>', function()
  vim.cmd.wincmd('j')
end, { desc = 'go to down window' })
vim.keymap.set({ 'n', 'i' }, '<C-Left>', function()
  vim.cmd.wincmd('h')
end, { desc = 'go to left window' })
vim.keymap.set({ 'n', 'i' }, '<C-Right>', function()
  vim.cmd.wincmd('l')
end, { desc = 'go to right window' })

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
end, { desc = '[g]it [s]stage hunk' })
vim.keymap.set('v', '<leader>gr', function()
  gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
end, { desc = '[g]it [r]eset hunk' })

vim.keymap.set('n', '<leader>gs', gitsigns.stage_hunk, { desc = '[g]it [s]tage hunk' })
vim.keymap.set('n', '<leader>gr', gitsigns.reset_hunk, { desc = '[g]it [r]eset hunk' })
vim.keymap.set('n', '<leader>gS', gitsigns.stage_buffer, { desc = '[g]it [S]tage buffer' })
vim.keymap.set('n', '<leader>gu', gitsigns.undo_stage_hunk, { desc = '[g]it [u]ndo stage hunk' })
vim.keymap.set('n', '<leader>gR', gitsigns.reset_buffer, { desc = '[g]it [R]eset buffer' })
vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk, { desc = '[g]it [p]review hunk' })
vim.keymap.set('n', '<leader>gb', gitsigns.blame_line, { desc = '[g]it [b]lame line' })
vim.keymap.set('n', '<leader>gd', gitsigns.diffthis, { desc = '[g]it [d]iff against index' })
vim.keymap.set('n', '<leader>gD', function()
  gitsigns.diffthis '@'
end, { desc = 'git [D]iff against last commit' })
vim.keymap.set('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[t]oggle git show [b]lame line' })
vim.keymap.set('n', '<leader>tD', gitsigns.toggle_deleted, { desc = '[t]oggle git show [D]eleted' })
