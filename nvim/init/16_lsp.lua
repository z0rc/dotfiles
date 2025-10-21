---@diagnostic disable-next-line: missing-fields
require('lazydev').setup({
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
})

require('blink.cmp').setup({
  cmdline = {
    enabled = false,
  },
  sources = {
    default = { 'lsp', 'path', 'buffer', 'snippets' },
    per_filetype = {
      codecompanion = { 'codecompanion', 'markview' },
      lua = { inherit_defaults = true, 'lazydev' },
      markdown = { 'markview' },
    },
    providers = {
      lazydev = {
        name = 'LazyDev',
        module = 'lazydev.integrations.blink',
        score_offset = 100,
      },
    },
  },
  keymap = {
    preset = 'enter',
  },
  fuzzy = {
    implementation = 'lua',
  },
  completion = {
    menu = {
      draw = {
        columns = {
          { 'label', 'label_description', gap = 1 },
          { 'kind' },
        },
        treesitter = { 'lsp' },
      },
    },
    list = {
      selection = {
        preselect = false,
      },
    },
    documentation = {
      auto_show = true,
    },
    trigger = {
      prefetch_on_insert = false,
    },
  },
  signature = {
    enabled = true,
    window = {
      show_documentation = false,
    },
  },
})

require('mason').setup()
require('mason-lspconfig').setup()

require('conform').setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    terraform = { 'terraform_fmt' },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = 'fallback',
  },
})
