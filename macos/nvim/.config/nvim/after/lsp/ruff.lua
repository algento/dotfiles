return {
  on_attach = function(client, bufnr)
    -- Disable hover in favor of Pyright.
    client.server_capabilities.signatureHelpProvider = false
    client.server_capabilities.hoverProvider = false
    -- client.server_capabilities.diagnosticProvider = false
  end,
}
