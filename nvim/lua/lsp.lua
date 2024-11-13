require('lazydev').setup({})

local lsp_zero = require('lsp-zero')

local lsp_attach = function(client, bufnr)
  lsp_zero.highlight_symbol(client, bufnr)
  lsp_zero.buffer_autoformat()
end

lsp_zero.extend_lspconfig({
  sign_text = true,
  lsp_attach = lsp_attach,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

local cmp = require('cmp')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp_action = lsp_zero.cmp_action()

cmp.setup({
  sources = {
    { name = 'lazydev',  group_index = 0 },
    { name = 'nvim_lsp', },
    {
      name = 'buffer',
      keyword_length = 3,
      entry_filter = function(entry)
        -- filter out too long suggestions, they are usually some hashes, which aren't useful here
        if string.len(entry.completion_item.label) >= 30 then
          return false
        else
          return true
        end
      end,
    },
    { name = 'path' },
    {
      name = 'spell',
      keyword_length = 3,
      entry_filter = function(entry)
        -- don't suggest entries that contain space, they aren't helpful
        if string.find(entry.completion_item.label, ' ') then
          return false
        else
          return true
        end
      end,
    },
  },
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<Tab>'] = cmp_action.vim_snippet_jump_forward(),
    ['<S-Tab>'] = cmp_action.vim_snippet_jump_backward(),
  }),
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = lsp_zero.cmp_format({ details = true }),
  preselect = 'item',
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
})
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

require('mason').setup()
require('mason-lspconfig').setup {
  handlers = {
    function(server_name) -- default handler for servers that don't require custom setup
      require('lspconfig')[server_name].setup {}
    end,
    lua_ls = function()
      require('lspconfig').lua_ls.setup(lsp_zero.nvim_lua_ls())
    end,
    jsonls = function()
      require('lspconfig').jsonls.setup {
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
        -- disable this lsp server syntax highlighting, it's garbage compared to what treesitter provides
        on_init = function(client)
          client.server_capabilities.semanticTokensProvider = nil
        end,
      }
    end,
  }
}
