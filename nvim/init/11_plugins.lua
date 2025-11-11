require('mini.basics').setup({
  options = {
    extra_ui = true,
  },
  autocommands = {
    relnum_in_visual_mode = true,
  },
})
require('mini.extra').setup()
require('mini.ai').setup({
  search_method = 'cover_or_nearest',
  custom_textobjects = {
    B = MiniExtra.gen_ai_spec.buffer(),
    F = require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
  },
})
require('mini.bracketed').setup()
require('mini.bufremove').setup()
require('mini.git').setup()
require('mini.diff').setup()
require('mini.pairs').setup({
  modes = { command = true },
})
require('mini.surround').setup({
  search_method = 'cover_or_nearest',
})
require('mini.comment').setup()
require('mini.notify').setup()
require('mini.pick').setup()
require('mini.indentscope').setup({
  draw = {
    delay = 0,
    animation = require('mini.indentscope').gen_animation.none(),
  },
})
require('mini.misc').setup()
MiniMisc.setup_auto_root()
MiniMisc.setup_restore_cursor()
require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons()

require('reticle').setup()
require('git-rebase-auto-diff').setup()
require('tmux').setup({
  navigation = { enable_default_keybindings = false },
  resize = { enable_default_keybindings = false },
})
require('schema-companion').setup({})
require('markview').setup({
  preview = {
    filetypes = { 'markdown', 'codecompanion' },
    ignore_buftypes = {},
  },
})
