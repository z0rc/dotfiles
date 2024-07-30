require('solarized').setup {
  theme = 'neo',
  highlights = function(color, helper)
    return {
      -- default green color is too contrast for this kind of symbols
      IblIndent = { fg = helper.darken(color.base01, 30), nocombine = true },
      IblScope = { fg = color.base01, nocombine = true },
      -- fix cursorline visibility
      CursorLineNr = { bg = color.base02 },
      CursorLine = { bg = color.base02 },
      -- fix lualine diff visibility
      LuaLineDiffAdd = { fg = helper.darken(color.green, 30) },
      LuaLineDiffChange = { fg = helper.darken(color.yellow, 30) },
      LuaLineDiffDelete = { fg = helper.darken(color.red, 30) },
    }
  end,
}

vim.cmd.colorscheme('solarized')
