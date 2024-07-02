---@diagnostic disable: undefined-field
local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(_, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})
end)

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')

cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'buffer' },
    { name = 'path' },
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  preselect = 'item',
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
})
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

require('mason').setup()
require('mason-lspconfig').setup {
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      require('lspconfig').lua_ls.setup(lsp_zero.nvim_lua_ls())
    end
  }
}
