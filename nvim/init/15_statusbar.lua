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
      'filetype',
      function()
        if vim.bo.filetype == 'yaml' or vim.bo.filetype == 'json' then
          return ('%s'):format(require('schema-companion').get_current_schemas())
        else
          return ''
        end
      end,
    },
  },
  extensions = { 'nvim-tree', 'mason', 'quickfix' },
}
