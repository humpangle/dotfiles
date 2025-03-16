local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.docker_lsp() then
  return {}
end

return {
  dockerls = {},
  hadolint = {},
}
