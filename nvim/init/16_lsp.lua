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
}

require('mason').setup()
require('mason-lspconfig').setup()

local augroup_lsp_format = vim.api.nvim_create_augroup('lsp-format-on-write', { clear = false })
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP configuration',
  group = vim.api.nvim_create_augroup('lsp-attach-config', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_formatting) then
      vim.api.nvim_clear_autocmds({ group = augroup_lsp_format, buffer = event.buf })
      vim.api.nvim_create_autocmd('BufWritePre', {
        desc = 'Format on write',
        group = augroup_lsp_format,
        buffer = event.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = event.buf })
        end,
      })
    end
  end,
})
