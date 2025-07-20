require('mini.git').setup()
require('mini.diff').setup()
require('mini.pairs').setup()
require('mini.surround').setup {
  search_method = 'cover_or_nearest',
}
require('mini.comment').setup()

require('ibl').setup {
  indent = {
    char = '│',
  },
}
require('reticle').setup()
require('rooter').setup({})
require('git-rebase-auto-diff').setup()
require('fidget').setup {
  notification = {
    override_vim_notify = true,
    window = {
      winblend = 30,
    },
  },
}
require('tmux').setup {
  navigation = { enable_default_keybindings = false },
  resize = { enable_default_keybindings = false },
}
require('ts-install').setup {
  auto_install = true,
  auto_update = true,
}
---@diagnostic disable-next-line: missing-fields
require('schema-companion').setup {
  enable_telescope = true,
  matchers = {
    require('schema-companion.matchers.kubernetes').setup({}),
  }
}
require('markview').setup(
  vim.tbl_deep_extend(
    'force',
    require('markview.presets').no_nerd_fonts,
    {
      preview = {
        filetypes = { 'markdown', 'codecompanion' },
        ignore_buftypes = {},
      },
    }
  )
)
