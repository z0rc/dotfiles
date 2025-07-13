require('codecompanion').setup {
  strategies = {
    chat = {
      adapter = 'gemini',
      model = 'gemini-2.5-pro',
    },
    inline = {
      adapter = 'gemini',
      model = 'gemini-2.5-pro',
    },
    cmd = {
      adapter = 'gemini',
      model = 'gemini-2.5-pro',
    }
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
}
