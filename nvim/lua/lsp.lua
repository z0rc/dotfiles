---@diagnostic disable: undefined-field
local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(_, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})
end)

lsp_zero.set_sign_icons({
  error = '✘',
  warn = '▲',
  hint = '⚑',
  info = '»'
})

local cmp = require('cmp')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp_action = lsp_zero.cmp_action()

cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer', keyword_length = 3 },
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
  formatting = lsp_zero.cmp_format({details = true}),
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
