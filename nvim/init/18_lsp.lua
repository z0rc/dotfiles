---@diagnostic disable-next-line: missing-fields
require('lazydev').setup {
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}

require('blink.cmp').setup {
  cmdline = {
    enabled = false,
  },
  sources = {
    default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
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

vim.api.nvim_create_autocmd('User', {
  desc = 'Hide Copilot suggestion when Blink menu is open',
  group = vim.api.nvim_create_augroup('copilot-suggestion-hide', { clear = true }),
  pattern = 'BlinkCmpMenuOpen',
  callback = function()
    vim.b.copilot_enabled = false
  end,
})

vim.api.nvim_create_autocmd('User', {
  desc = 'Show Copilot suggestion when Blink menu is closed',
  group = vim.api.nvim_create_augroup('copilot-suggestion-show', { clear = true }),
  pattern = "BlinkCmpMenuClose",
  callback = function()
    vim.b.copilot_enabled = true
  end,
})

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
