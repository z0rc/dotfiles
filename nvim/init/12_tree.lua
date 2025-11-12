require('nvim-tree').setup({
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = {
      enable = true,
      ignore_list = {
        'help',
        'git',
      },
    },
    exclude = function(event) return event.file:find(vim.fn.getcwd() .. '/.git/', 1, true) == 1 end,
  },
  sort = {
    sorter = 'case_sensitive',
  },
  hijack_cursor = true,
  git = {
    show_on_open_dirs = false,
  },
  modified = {
    enable = true,
    show_on_open_dirs = false,
  },
  filters = {
    git_ignored = false,
  },
  renderer = {
    highlight_opened_files = 'name',
    indent_markers = {
      enable = true,
    },
    full_name = true,
    group_empty = true,
    icons = {
      git_placement = 'signcolumn',
    },
  },
})

-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup
local function open_nvim_tree(data)
  -- buffer is a real file on the disk
  local real_file = vim.fn.filereadable(data.file) == 1

  -- buffer is a [No Name]
  local no_name = data.file == '' and vim.bo[data.buf].buftype == ''

  if not real_file and not no_name then return end

  -- skip files in TMPDIR, kubectl does this when editing resources
  local tmpdir = vim.env.TMPDIR or '/tmp/'
  if string.find(data.file, tmpdir) then return end

  -- skip specific filetypes
  local IGNORED_FILETYPES = {
    'gitcommit',
    'gitrebase',
    'crontab',
  }

  local filetype = vim.bo[data.buf].ft

  if vim.tbl_contains(IGNORED_FILETYPES, filetype) then return end

  -- open the tree, find the file but don't focus it
  require('nvim-tree.api').tree.toggle({ focus = false, find_file = true })
end

vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_nvim_tree })

-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close
vim.api.nvim_create_autocmd('QuitPre', {
  callback = function()
    local tree_wins = {}
    local floating_wins = {}
    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if bufname:match('NvimTree_') ~= nil then table.insert(tree_wins, w) end
      if vim.api.nvim_win_get_config(w).relative ~= '' then table.insert(floating_wins, w) end
    end
    if 1 == #wins - #floating_wins - #tree_wins then
      -- Should quit, so we close all invalid windows.
      for _, w in ipairs(tree_wins) do
        vim.api.nvim_win_close(w, true)
      end
    end
  end,
})
