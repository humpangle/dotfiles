local plugin_enabled = require("plugins/plugin_enabled")

if plugin_enabled.has_vscode() then
  return {}
end

local utils = require("utils")

return {
  "pwntester/octo.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "ibhagwan/fzf-lua",
    -- OR "nvim-telescope/telescope.nvim",
    -- OR 'folke/snacks.nvim',
    "nvim-tree/nvim-web-devicons",
  },
  init = function()
    vim.api.nvim_create_user_command("Delocto", function()
      utils.DeleteAllBuffers("octo")
    end, {})
    vim.api.nvim_create_user_command("OctoDelete", function()
      utils.DeleteAllBuffers("octo")
    end, {})
  end,
  cmd = {
    "Octo",
  },
  config = function()
    require("octo").setup({
      -- `true` will not work where nvim CWD != git CWD
      use_local_fs = false, -- use local files on right side of reviews
      enable_builtin = true, -- shows a list of builtin actions when no action is provided
      picker = "fzf-lua", -- or "telescope"
      picker_config = {
        use_emojis = true, -- only used by "fzf-lua" picker for now
        mappings = { -- mappings for the pickers
          open_in_browser = {
            lhs = "<C-b>",
            desc = "open issue in browser",
          },
          copy_url = {
            lhs = "<C-y>",
            desc = "copy url to system clipboard",
          },
          checkout_pr = {
            lhs = "<C-o>",
            desc = "checkout pull request",
          },
          merge_pr = { lhs = "<C-r>", desc = "merge pull request" },
        },
      },
    })
  end,
}
