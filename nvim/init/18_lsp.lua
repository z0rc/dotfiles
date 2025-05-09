---@diagnostic disable-next-line: missing-fields
require('lazydev').setup {
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}

require('copilot').setup {
  suggestion = { enabled = false },
  panel = { enabled = false },
}

require('blink-copilot').setup {}

require('blink.cmp').setup {
  cmdline = {
    enabled = false,
  },
  sources = {
    default = { 'copilot', 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      lazydev = {
        name = 'LazyDev',
        module = 'lazydev.integrations.blink',
        score_offset = 100,
      },
      copilot = {
        name = 'copilot',
        module = 'blink-copilot',
        score_offset = 200,
        async = true,
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
          { 'kind' }
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
  },
  signature = {
    enabled = true,
    window = {
      show_documentation = false,
    },
  },
}

require('mason').setup()
require('mason-lspconfig').setup {
  ensure_installed = {},
  automatic_installation = false,
  automatic_enable = true,
}

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP configuration',
  group = vim.api.nvim_create_augroup('lsp-attach-configuration', { clear = false }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_formatting) then
      vim.api.nvim_create_autocmd('BufWritePre', {
        desc = 'Format on write',
        group = vim.api.nvim_create_augroup('write-format', { clear = true }),
        buffer = event.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = event.buf })
        end,
      })
    end
  end,
})
