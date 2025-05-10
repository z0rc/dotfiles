return {
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
