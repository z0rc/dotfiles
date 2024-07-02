require('lualine').setup {
  options = {
    theme = 'solarized',
    disabled_filetypes = {
      'NvimTree',
    },
    icons_enabled = false,
    component_separators = '',
    section_separators = '',
  },
  extensions = {'mason', 'quickfix'},
}
