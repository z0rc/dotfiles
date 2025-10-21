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
    chat = {
      icons = {
        buffer_pin = '📌 ',
        buffer_watch = '🔎 ',
        tool_success = '✅ ',
        tool_failure = '❌ ',
      },
    },
    action_palette = {
      provider = 'mini_pick',
    },
    diff = {
      provider = 'mini_diff',
    },
  },
  icons = {
    loading = '◷ ',
    warning = '⚠ ',
  },
  extensions = {
    spinner = {},
  },
})
