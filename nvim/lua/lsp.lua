require('lazydev').setup()

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
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },
  },
}

require('mason').setup()
---@diagnostic disable-next-line: missing-fields
require('mason-lspconfig').setup {
  handlers = {
    function(server_name) -- default handler for servers that don't require custom setup
      require('lspconfig')[server_name].setup{
        capabilities = require('blink.cmp').get_lsp_capabilities()
      }
    end,
    jsonls = function()
      require('lspconfig').jsonls.setup {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      }
    end,
    yamlls = function()
      require('lspconfig').yamlls.setup(require('yaml-companion').setup {
        lspconfig = {
          capabilities = require('blink.cmp').get_lsp_capabilities(),
          settings = {
            yaml = {
              format = { enable = false },
              customTags = { '!reference sequence' },
            },
          },
        },
      })
    end,
    terraformls = function()
      require('lspconfig').terraformls.setup {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
        -- disable this lsp server syntax highlighting, it's garbage compared to what treesitter provides
        on_init = function(client)
          client.server_capabilities.semanticTokensProvider = nil
        end,
      }
    end,
  }
}
