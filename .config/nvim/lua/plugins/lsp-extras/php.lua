local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.php_lsp() then
  return {}
end

local utils = require("utils")

return {
  intelephense = {
    init_options = {

      -- Optional licence key or absolute path to a text file containing the licence key.
      licenceKey = utils.get_os_env_or_nil("INTELEPHENSE_LICENCE") or "",
    },
  },
}
