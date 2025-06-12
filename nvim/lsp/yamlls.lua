---@diagnostic disable-next-line: missing-fields
return require('schema-companion').setup_client({
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
})
