local adapter = vim.g.llm_adapter or 'claude_code'

require('codecompanion').setup({
  interactions = {
    chat = {
      adapter = adapter,
    },
    inline = {
      adapter = adapter,
    },
  },
  extensions = {
    spinner = {},
  },
})
