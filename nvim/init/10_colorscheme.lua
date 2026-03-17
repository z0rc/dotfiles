require('solarized').setup({
  variant = 'autumn',
  on_highlights = function(colors, helper)
    return {
      -- undercurl the spelling errors
      SpellBad = { strikethrough = false, underline = false, sp = colors.red, undercurl = true },
      SpellCap = { sp = colors.violet, undercurl = true },
      SpellLocal = { sp = colors.yellow, undercurl = true },
      SpellRare = { sp = colors.cyan, undercurl = true },
      -- better mini.diff readability
      MiniDiffOverAdd = { fg = colors.git_add },
      MiniDiffOverChange = { fg = helper.blend(colors.git_modify, colors.git_delete, 0.5) },
      MiniDiffOverChangeBuf = { fg = helper.blend(colors.git_modify, colors.git_add, 0.5) },
      MiniDiffOverContext = { fg = colors.git_delete },
      MiniDiffOverContextBuf = { fg = colors.git_add },
      MiniDiffOverDelete = { fg = colors.git_delete },
      -- proper mini.indentscope highlight
      MiniIndentscopeSymbol = { fg = colors.base01 },
    }
  end,
})

vim.cmd.colorscheme('solarized')
