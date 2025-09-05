return require('schema-companion').setup_client(
  require('schema-companion').adapters.yamlls.setup({
    sources = {
      require('schema-companion').sources.matchers.kubernetes.setup({ version = 'master' }),
      require('schema-companion').sources.lsp.setup(),
    },
  }),
  {
    settings = {
      yaml = {
        schemaStore = {
          enable = true,
          url = '',
        },
        schemas = require('schemastore').yaml.schemas(),
        format = { enable = false },
        customTags = { '!reference sequence' },
      },
    },
  }
)
