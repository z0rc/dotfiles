---@diagnostic disable-next-line: missing-fields
require('lazydev').setup {
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
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
  handlers = {
    function(server_name) -- default handler for servers that don't require custom setup
      vim.lsp.enable(server_name)
    end,
    jsonls = function()
      vim.lsp.config('jsonls', {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        }
      })
      vim.lsp.enable('jsonls')
    end,
    yamlls = function()
      vim.lsp.config('yamlls', require('yaml-companion').setup {
        lspconfig = {
          settings = {
            yaml = {
              format = { enable = false },
              customTags = { '!reference sequence' },
            },
          },
        },
      })
      vim.lsp.enable('yamlls')
    end,
    terraformls = function()
      vim.lsp.config('terraformls', {
        -- disable this lsp server syntax highlighting, it's garbage compared to what treesitter provides
        on_init = function(client)
          client.server_capabilities.semanticTokensProvider = nil
        end,
      })
      vim.lsp.enable('terraformls')
    end,
  }
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
