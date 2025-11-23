vim = vim
local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.python() then
  return {}
end

-- basedpyright = {

return {
  pyright = {
    on_init = function(client)
      local workspace = client.config.root_dir
      local python_bin = require("plugins/lsp-extras/lsp_utils").get_python_path(workspace)
      client.config.settings.python.pythonPath = python_bin
      vim.g.python_host_prog = python_bin
      vim.g.python3_host_prog = python_bin
    end,
  },
  -- for mason to automatically download
  black = {},
  isort = {},
  flake8 = {},
  mypy = {},
  -- pylint = {},
  debugpy = {},
}
