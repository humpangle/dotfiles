local plugin_enabled = require("plugins/plugin_enabled")

if plugin_enabled.has_vscode() then
  return {}
end

local utils = require("utils")
local map_lazy_key = utils.map_lazy_key

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
  keys = {
    map_lazy_key("<leader>gh0", function()
      vim.cmd("Octo")
    end, { desc = "Octo" }),

    map_lazy_key("<leader>ghp", function()
      local count = vim.v.count

      if count == 0 then
        vim.cmd("tab split")
        vim.cmd("Octo pr list")
        return
      end

      if count == 1 then
        vim.cmd("Octo pr checkout")
        return
      end

      if count == 2 then
        vim.cmd("Octo pr reload")
        return
      end
    end, { desc = "Octo PR 0/ls 1/checkout 2/reload" }),

    map_lazy_key("<leader>ghr", function()
      local count = vim.v.count

      if count == 0 then
        vim.cmd("Octo review")
        return
      end

      if count == 1 then
        vim.cmd("Octo review resume")
        return
      end

      if count == 2 then
        vim.cmd("Octo review submit")
        return
      end
    end, { desc = "Octo Review 0/start 1/resume 2/submit" }),
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
          merge_pr = { lhs = "<C-r>", desc = "merge pull request" },
        },
      },
    })
  end,
}
