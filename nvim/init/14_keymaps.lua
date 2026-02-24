-- simple shorthands
local nimap = function(lhs, rhs, desc) vim.keymap.set({ 'n', 'i' }, lhs, rhs, { desc = desc }) end
local cmap = function(lhs, rhs) vim.keymap.set('c', lhs, rhs, { expr = true }) end
local vmap = function(lhs, rhs) vim.keymap.set('v', lhs, rhs) end
local nmap_leader = function(suffix, rhs, desc) vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc }) end
local xmap_leader = function(suffix, rhs, desc) vim.keymap.set('x', '<Leader>' .. suffix, rhs, { desc = desc }) end

-- sanity https://github.com/neovim/neovim/issues/9953#issuecomment-1732700161
cmap('<Up>', function() return vim.fn.wildmenumode() == 1 and '<Left>' or '<Up>' end)
cmap('<Down>', function() return vim.fn.wildmenumode() == 1 and '<Right>' or '<Down>' end)
cmap('<Left>', function() return vim.fn.wildmenumode() == 1 and '<Up>' or '<Left>' end)
cmap('<Right>', function() return vim.fn.wildmenumode() == 1 and '<Down>' or '<Right>' end)

-- tmux/split navigation
local tmux = require('tmux')
nimap('<S-Up>', tmux.move_top, 'Go to up pane')
nimap('<S-Down>', tmux.move_bottom, 'Go to down pane')
nimap('<S-Left>', tmux.move_left, 'Go to left pane')
nimap('<S-Right>', tmux.move_right, 'Go to right pane')

-- visual shifting (does not exit visual mode)
vmap('<', '<gv')
vmap('>', '>gv')

-- telescope
nmap_leader('f/', '<Cmd>Pick history scope="/"<CR>', '"/" history')
nmap_leader('f:', '<Cmd>Pick history scope=":"<CR>', '":" history')
nmap_leader('fa', require('codecompanion').actions, 'CodeCompanion actions')
nmap_leader('fb', '<Cmd>Pick buffers<CR>', 'Buffers')
nmap_leader('fc', '<Cmd>Pick git_commits<CR>', 'Commits (all)')
nmap_leader('fC', '<Cmd>Pick git_commits path="%"<CR>', 'Commits (buf)')
nmap_leader('fd', '<Cmd>Pick diagnostic scope="all"<CR>', 'Diagnostic workspace')
nmap_leader('fD', '<Cmd>Pick diagnostic scope="current"<CR>', 'Diagnostic buffer')
nmap_leader('ff', '<Cmd>Pick files<CR>', 'Files')
nmap_leader('fg', '<Cmd>Pick grep_live<CR>', 'Grep live')
nmap_leader('fG', '<Cmd>Pick grep pattern="<cword>"<CR>', 'Grep current word')
nmap_leader('fh', '<Cmd>Pick help<CR>', 'Help tags')
nmap_leader('fH', '<Cmd>Pick hl_groups<CR>', 'Highlight groups')
nmap_leader('fl', '<Cmd>Pick buf_lines scope="all"<CR>', 'Lines (all)')
nmap_leader('fL', '<Cmd>Pick buf_lines scope="current"<CR>', 'Lines (buf)')
nmap_leader('fm', '<Cmd>Pick git_hunks<CR>', 'Modified hunks (all)')
nmap_leader('fM', '<Cmd>Pick git_hunks path="%"<CR>', 'Modified hunks (buf)')
nmap_leader('fr', '<Cmd>Pick resume<CR>', 'Resume')
nmap_leader('fR', '<Cmd>Pick lsp scope="references"<CR>', 'References (LSP)')
nmap_leader('fs', require('schema-companion').select_schema, 'YAML/JSON Schema')
nmap_leader('fu', '<Cmd>Pick git_hunks scope="staged"<CR>', 'Added hunks (all)')
nmap_leader('fU', '<Cmd>Pick git_hunks path="%" scope="staged"<CR>', 'Added hunks (buf)')
nmap_leader('fv', '<Cmd>Pick visit_paths cwd=""<CR>', 'Visit paths (all)')
nmap_leader('fV', '<Cmd>Pick visit_paths<CR>', 'Visit paths (cwd)')
nmap_leader('fy', '<Cmd>Pick lsp scope="workspace_symbol"<CR>', 'Symbols workspace')
nmap_leader('fY', '<Cmd>Pick lsp scope="document_symbol"<CR>', 'Symbols document')

-- git
nmap_leader('ga', '<Cmd>Git diff --cached<CR>', 'Added diff')
nmap_leader('gA', '<Cmd>Git diff --cached -- %<CR>', 'Added diff buffer')
nmap_leader('gc', '<Cmd>Git commit<CR>', 'Commit')
nmap_leader('gC', '<Cmd>Git commit --amend<CR>', 'Commit amend')
nmap_leader('gd', '<Cmd>Git diff<CR>', 'Diff')
nmap_leader('gD', '<Cmd>Git diff -- %<CR>', 'Diff buffer')
nmap_leader('gl', [[<Cmd>Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order<CR>]], 'Log')
nmap_leader('gL', [[<Cmd>Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order --follow -- %<CR>]], 'Log buffer')
nmap_leader('gs', MiniGit.show_at_cursor, 'Show at cursor')
xmap_leader('gs', MiniGit.show_at_cursor, 'Show at selection')

-- lsp
nmap_leader('la', vim.lsp.buf.code_action, 'Actions')
nmap_leader('ld', vim.diagnostic.open_float, 'Diagnostic popup')
nmap_leader('lf', require('conform').format, 'Format')
xmap_leader('lf', require('conform').format, 'Format selection')
nmap_leader('li', vim.lsp.buf.implementation, 'Implementation')
nmap_leader('lh', vim.lsp.buf.hover, 'Hover')
nmap_leader('lr', vim.lsp.buf.rename, 'Rename')
nmap_leader('lR', vim.lsp.buf.references, 'References')
nmap_leader('ls', vim.lsp.buf.definition, 'Source definition')
nmap_leader('lt', vim.lsp.buf.type_definition, 'Type definition')
nmap_leader('lS', require('schema-companion').select_schema, 'Select schema')

-- buffers
nmap_leader('ba', '<Cmd>b#<CR>', 'Alternate')
nmap_leader('bd', MiniBufremove.delete, 'Delete')
nmap_leader('bD', function() MiniBufremove.delete(0, true) end, 'Delete!')
nmap_leader('bs', function() vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true)) end, 'Scratch')
nmap_leader('bw', MiniBufremove.wipeout, 'Wipeout')
nmap_leader('bW', function() MiniBufremove.wipeout(0, true) end, 'Wipeout!')

-- toggles
nmap_leader('tt', require('nvim-tree.api').tree.toggle, 'NvimTree')
nmap_leader('tm', require('markview').commands.toggle, 'Markdown rendering')
nmap_leader('tc', require('codecompanion').toggle, 'CodeCompanion chat')
nmap_leader('td', require('mini.diff').toggle_overlay, 'Diff overlay')
