require('solarized').setup {
  theme = 'neo',
  highlights = function(color, helper)
    return {
      -- default green color is too contrast for this kind of symbols
      IblIndent = { fg = helper.darken(color.base01, 30), nocombine = true },
      IblScope = { fg = color.base01, nocombine = true },
    }
  end,
}

vim.cmd.colorscheme('solarized')
