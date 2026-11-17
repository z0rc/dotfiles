return {
  settings = {
    Lua = {
      -- KB, the 500 default skips schemastore's catalog.lua
      workspace = { preloadFileSize = 1000 },
    },
  },
}
