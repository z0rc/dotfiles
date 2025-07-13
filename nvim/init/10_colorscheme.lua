require('solarized').setup {
  variant = 'autumn',
  on_highlights = function(colors, helper)
    return {
      -- fix lualine diff visibility
      LuaLineDiffAdd = { fg = helper.darken(colors.git_add, 30) },
      LuaLineDiffChange = { fg = helper.darken(colors.git_modify, 30) },
      LuaLineDiffDelete = { fg = helper.darken(colors.git_delete, 30) },
      -- only underline the spelling errors
      SpellBad = { strikethrough = false, underline = true },
      -- better mini.diff readability
      MiniDiffOverAdd = { fg = colors.git_add },
      MiniDiffOverChange = { fg = helper.blend(colors.git_modify, colors.git_delete, 0.5) },
      MiniDiffOverChangeBuf = { fg = helper.blend(colors.git_modify, colors.git_add, 0.5) },
      MiniDiffOverContext = { fg = colors.git_delete },
      MiniDiffOverContextBuf = { fg = colors.git_add },
      MiniDiffOverDelete = { fg = colors.git_delete },
    }
  end,
}

vim.cmd.colorscheme('solarized')
