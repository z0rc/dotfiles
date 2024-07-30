require('lazydev').setup({})

local lsp_zero = require('lsp-zero')

local lsp_attach = function(client, bufnr)
  lsp_zero.default_keymaps({ buffer = bufnr })
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
    { name = 'lazydev', group_index = 0 },
    { name = 'nvim_lsp' },
    { name = 'buffer',  keyword_length = 3 },
    { name = 'path' },
  },
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-f>'] = cmp_action.vim_snippet_jump_forward(),
    ['<C-b>'] = cmp_action.vim_snippet_jump_backward(),
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
  }
}
