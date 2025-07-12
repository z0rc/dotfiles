require('lualine').setup {
  options = {
    globalstatus = true,
    theme = 'solarized',
    icons_enabled = false,
    component_separators = '',
    section_separators = '',
  },
  sections = {
    lualine_x = {
      { require 'minuet.lualine',
        display_name = 'provider',
      },
      'filetype',
      function()
        if vim.bo.filetype == 'yaml' then
          return ('%s'):format(require('schema-companion.context').get_buffer_schema().name)
        else
          return ''
        end
      end,
    },
  },
  extensions = { 'nvim-tree', 'mason', 'quickfix' },
}
