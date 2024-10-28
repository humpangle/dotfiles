local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.emmet_lsp() then
  return {}
end

return {
  emmet_language_server = {
    filetypes = {
      "css",
      "eruby",
      "html",
      "javascript",
      "javascriptreact",
      "less",
      "sass",
      "scss",
      "pug",
      "typescriptreact",
      "eex",
      "elixir",
      "eelixir",
      "heex",
    },
  },
}
