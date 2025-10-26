-- Python formatter

local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.python() then
  return {}
end

vim.api.nvim_create_user_command("Isort", function()
  vim.cmd("w")
  vim.cmd("silent !isort %")
end, {})

return {
  {
    -- https://github.com/psf/black
    --  You must `pip install -U pynvim` into the python executable
    "psf/black",
    ft = "python",
  },
}
