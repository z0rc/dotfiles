require('lualine').setup {
  options = {
    icons_enabled = false,
    component_separators = '',
    section_separators = '',
  },
  extensions = {'mason', 'nvim-tree', 'quickfix'},
}
