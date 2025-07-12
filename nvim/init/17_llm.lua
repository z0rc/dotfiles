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
  },
  icons = {
    loading = '◷ ',
    warning = '⚠ ',
  },
  extensions = {
    spinner = {},
  },
}

require('minuet').setup {
  provider = 'gemini',
  provider_options = {
    gemini = {
      model = 'gemini-2.5-flash',
    },
  },
}
