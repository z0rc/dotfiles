require('codecompanion').setup({
  strategies = {
    chat = {
      adapter = 'gemini_cli',
    },
    inline = {
      adapter = 'gemini_cli',
    },
    cmd = {
      adapter = 'gemini_cli',
    },
  },
  display = {
    action_palette = {
      provider = 'mini_pick',
    },
    diff = {
      provider = 'mini_diff',
    },
  },
  extensions = {
    spinner = {},
  },
})
