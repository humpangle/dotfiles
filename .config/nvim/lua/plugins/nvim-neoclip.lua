local plugin_enabled = require("plugins/plugin_enabled")

if plugin_enabled.has_vscode() then
  return {}
end

local utils = require('utils')

return {
  -- {
  --   "gennaro-tedesco/nvim-peekup",
  -- },
  {
    "AckslD/nvim-neoclip.lua",
    dependencies = {
      {
        "kkharji/sqlite.lua",
        module = "sqlite",
      },
      -- you'll need at least one of these
      {
        "nvim-telescope/telescope.nvim",
      },
      -- {'ibhagwan/fzf-lua'},
    },
    config = function()
      require("neoclip").setup({
        enable_persistent_history = true,
      })

      utils.map_key("n", "<leader>re", ":Telescope neoclip<CR>", { noremap = true })
    end,
  },
}
