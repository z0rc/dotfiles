return require('schema-companion').setup_client(
  require('schema-companion').adapters.jsonls.setup({
    sources = {
      require('schema-companion').sources.lsp.setup(),
    },
  }),
  {
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      },
    },
  }
)
