return require('yaml-companion').setup {
  lspconfig = {
    settings = {
      yaml = {
        format = { enable = false },
        schemas = require('schemastore').yaml.schemas(),
        schemaStore = { enable = false },
        customTags = { '!reference sequence' },
      },
    },
  },
}
