local utils = require("utils")
local map_key = utils.map_key

local diagnostic_config_opts = {
  virtual_lines = true,
  -- virtual_lines = {
  --   current_line = true,
  -- },
}

vim.diagnostic.config(diagnostic_config_opts)

map_key("n", "<leader>lsd", function()
  local count = vim.v.count

  if count == 0 then
    diagnostic_config_opts.virtual_lines =
      not diagnostic_config_opts.virtual_lines
    vim.diagnostic.config(diagnostic_config_opts)
    return
  end
end, { desc = "diagnostic 0/toggleVirtualLine" })
