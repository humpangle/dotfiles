local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.firenvim() then
  return {}
end

return {
  "glacambre/firenvim",
  build = ":call firenvim#install(0)",
}
