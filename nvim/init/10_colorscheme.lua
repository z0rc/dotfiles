require('solarized').setup({
  variant = 'autumn',
  transparent = {
      enabled = true,         -- Master switch to enable transparency
      pmenu = true,           -- Popup menu (e.g., autocomplete suggestions)
      normal = true,          -- Main editor window background
      normalfloat = true,     -- Floating windows
      neotree = true,         -- Neo-tree file explorer
      nvimtree = true,        -- Nvim-tree file explorer
      whichkey = true,        -- Which-key popup
      telescope = true,       -- Telescope fuzzy finder
      lazy = true,            -- Lazy plugin manager UI
      mason = true,           -- Mason manage external tooling
  },
  on_highlights = function(colors, helper)
    return {
      -- only underline the spelling errors
      SpellBad = { strikethrough = false, underline = true },
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
