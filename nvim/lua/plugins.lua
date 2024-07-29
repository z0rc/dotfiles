require('gitsigns').setup({})
require('ibl').setup {
  indent = {
    char = '│',
  },
}
require('reticle').setup({})
require('nvim-surround').setup({})
require('nvim-autopairs').setup({})
require('project_nvim').setup({})
require('diffview').setup {
  use_icons = false,
  signs = {
    fold_closed = '>',
    fold_open = 'v',
    done = '✓',
  },
}
require('git-rebase-auto-diff').setup({})
