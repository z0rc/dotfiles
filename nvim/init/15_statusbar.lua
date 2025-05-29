require('lualine').setup {
  options = {
    theme = 'solarized',
    disabled_filetypes = {
      'NvimTree',
      'git',
      'fugitive',
      'fugitiveblame'
    },
    icons_enabled = false,
    component_separators = '',
    section_separators = '',
  },
  sections = {
    lualine_x = { 'fileformat', 'filetype', get_yaml_schema },
  },
  extensions = { 'mason', 'quickfix' },
}
