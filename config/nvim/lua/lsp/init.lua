local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
    return
end

require "lsp.install-and-start-server"
require("lsp.client-config").setup()
