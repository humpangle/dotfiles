local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.has_web_browsers() then
  return {}
end

local utils = require("utils")
local keymap = utils.map_key

return {
  {
    -- Install extension:
    -- GhostText
    "subnut/nvim-ghost.nvim",
    -- cmd = {
    --   "GhostTextStart",
    -- },
    init = function()
      vim.g.nvim_ghost_autostart = 0
      -- vim.g.nvim_ghost_server_port = 4001

      -- vim.api.nvim_create_autocmd("User", {
      --   pattern = "*",
      --   callback = function()
      --     vim.bo.filetype = "markdown"
      --   end,
      -- })

      keymap("n", "<leader>we0", function()
        vim.cmd("GhostTextStart")
      end)
    end,
  },
  {
    "yuratomo/w3m.vim",
    cmd = {
      "W3m",
      "W3mHistory",
      "W3mHistoryClear",
      "W3mLocal",
      "W3mSplit",
      "W3mTab",
      "W3mVSplit",
    },
  },
  {
    "glacambre/firenvim",
    build = ":call firenvim#install(0)",
  },
}
