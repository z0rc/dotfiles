require('mini.ai').setup()
require('mini.git').setup()
require('mini.diff').setup()
require('mini.pairs').setup()
require('mini.surround').setup {
  search_method = 'cover_or_nearest',
}
require('mini.comment').setup()
require('mini.misc').setup()
MiniMisc.setup_auto_root()
MiniMisc.setup_restore_cursor()

require('ibl').setup {
  indent = {
    char = '│',
  },
}
require('reticle').setup()
require('git-rebase-auto-diff').setup()
require('fidget').setup {
  notification = {
    override_vim_notify = true,
  },
}
require('tmux').setup {
  navigation = { enable_default_keybindings = false },
  resize = { enable_default_keybindings = false },
}
require('schema-companion').setup({})
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
