-- get yaml schema for current buffer
local function get_yaml_schema()
  local schema = require('yaml-companion').get_buf_schema(0)
  if schema.result[1].name == 'none' then
    return ''
  end
  return schema.result[1].name
end

require('lualine').setup {
  options = {
    theme = 'solarized',
    disabled_filetypes = {
      'NvimTree',
      'git',
      'crontab',
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
