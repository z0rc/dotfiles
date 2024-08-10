require('gitsigns').setup {
  current_line_blame_opts = {
    virt_text_pos = 'right_align',
  },
}
require('ibl').setup {
  indent = {
    char = '│',
  },
}
require('reticle').setup({})
require('nvim-surround').setup({})
require('surround-ui').setup {
  root_key = 's',
}
require('nvim-autopairs').setup({})
require('project_nvim').setup({})
require('diffview').setup {
  use_icons = false,
  signs = {
    fold_closed = '>',
    fold_open = 'v',
  },
}
require('git-rebase-auto-diff').setup({})
require('fidget').setup {
  notification = {
    override_vim_notify = true,
    window = {
      winblend = 30,
    },
  },
}
