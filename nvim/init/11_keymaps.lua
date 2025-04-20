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
vim.keymap.set('n', '<leader>gu', gitsigns.stage_hunk, { desc = '[u]ndo stage hunk' })
vim.keymap.set('n', '<leader>gR', gitsigns.reset_buffer, { desc = '[R]eset buffer' })
vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk, { desc = '[p]review hunk' })
vim.keymap.set('n', '<leader>gb', gitsigns.blame_line, { desc = '[b]lame line' })
vim.keymap.set('n', '<leader>gd', gitsigns.diffthis, { desc = '[d]iff against index' })
vim.keymap.set('n', '<leader>gD', function()
  gitsigns.diffthis '@'
end, { desc = '[D]iff against last commit' })
vim.keymap.set('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'git [b]lame line' })
vim.keymap.set('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = 'git [D]eleted' })

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
vim.keymap.set('n', '<leader>fp', require('telescope').extensions.projects.projects, { desc = '[p]rojects' })
vim.keymap.set('n', '<leader>fy', require('yaml-companion').open_ui_select, { desc = '[y]aml schema' })

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

-- fugitive
vim.keymap.set('n', '<leader>tB', function()
  local windows = vim.api.nvim_list_wins()
  for _, v in pairs(windows) do
    if vim.fn.getbufvar(vim.fn.winbufnr(v), '&filetype') == 'fugitiveblame' then
      vim.api.nvim_win_close(v, false)
      return
    end
  end
  vim.cmd.Git('blame')
end, { desc = 'git [B]lame buffer' })
vim.keymap.set('n', '<leader>tg', function()
  local windows = vim.api.nvim_list_wins()
  for _, v in pairs(windows) do
    local status = pcall(vim.api.nvim_win_get_var, v, 'fugitive_status')
    if status then
      vim.api.nvim_win_close(v, false)
      return
    end
  end
  vim.cmd('Git')
end, { desc = '[g]it status' })

-- copilot
vim.keymap.set('i', '<Right>', 'copilot#Accept("<Right>")',
  { expr = true, replace_keycodes = false, desc = 'Accept Copilot suggestion' })
vim.keymap.set('i', '<C-Right>', 'copilot#AcceptWord("<C-Right>")',
  { expr = true, replace_keycodes = false, desc = 'Accept Copilot word' })
vim.keymap.set('i', '<C-Down>', 'copilot#AcceptLine("<C-Down>")',
  { expr = true, replace_keycodes = false, desc = 'Accept Copilot line' })
