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
    lualine_x = {
      'fileformat',
      'filetype',
      function()
        return ('%s'):format(require('schema-companion.context').get_buffer_schema().name)
      end,
    },
  },
  extensions = { 'mason', 'quickfix' },
}
