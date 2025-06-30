require('solarized').setup {
  variant = 'autumn',
  on_highlights = function(colors, helper)
    return {
      -- fix lualine diff visibility
      LuaLineDiffAdd = { fg = helper.darken(colors.green, 30) },
      LuaLineDiffChange = { fg = helper.darken(colors.yellow, 30) },
      LuaLineDiffDelete = { fg = helper.darken(colors.red, 30) },
      SpellBad = { strikethrough = false },
    }
  end,
}

vim.cmd.colorscheme('solarized')
