return require('schema-companion').setup_client(
  require('schema-companion').adapters.helmls.setup({
    sources = {
      require('schema-companion').sources.matchers.kubernetes.setup({ version = 'master' }),
    },
  }),
  {
    settings = {
      yamlls = {
        path = vim.fn.stdpath('data') .. '/mason/bin/yaml-language-server',
      },
    },
  }
)
