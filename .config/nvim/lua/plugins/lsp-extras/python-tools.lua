-- Python formatter

local utils = require("utils")
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
    config = function()
      -- Force keymap `leader fc` to use Neoformat for certain file types
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = {
          "python",
        },
        callback = function()
          utils.map_key("n", "<leader>fc", function()
            vim.cmd("Black")
          end, {
            noremap = true,
            buffer = true,
          })
        end,
      })
    end,
  },
}
