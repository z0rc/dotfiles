require('codecompanion').setup({
  adapters = {
    acp = {
      extend = vim.g.llm_acp_extend,
    },
  },
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
