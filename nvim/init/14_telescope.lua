require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<Esc>'] = 'close',
        ['<C-c>'] = false,
      },
    },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown()
    },
  },
}

require('telescope').load_extension('ui-select')
require('telescope').load_extension('fidget')
