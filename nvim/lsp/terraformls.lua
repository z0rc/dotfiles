return {
  -- disable this lsp server syntax highlighting, it's garbage compared to what treesitter provides
  on_init = function(client)
    client.server_capabilities.semanticTokensProvider = nil
  end,
}
