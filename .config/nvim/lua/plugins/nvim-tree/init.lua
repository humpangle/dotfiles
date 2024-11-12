local plugin_enabled = require("plugins/plugin_enabled")

if plugin_enabled.has_vscode() then
  return {}
end

return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    init = function()
      -- optionally enable 24-bit colour
      vim.opt.termguicolors = true

      local map_key = require("utils").map_key

      map_key("n", "\\", function()
        local count = vim.v.count

        if count == 0 then
          vim.cmd("NvimTreeOpen %:h")
          return
        end

        if count == 1 then
          vim.cmd("NvimTreeOpen")
        end
      end, {
        desc = "Nvim-tree --",
      })
    end,
    config = function()
      local helpers = require("plugins/nvim-tree/helpers")

      require("nvim-tree").setup({
        on_attach = helpers.on_attach,

        disable_netrw = true,

        view = {
          width = 60,
          number = true,
          relativenumber = true,
        },

        renderer = {
          -- group_empty = true,
        },

        filters = {
          enable = false,
        },

        filesystem_watchers = {
          enable = true,
          debounce_delay = 50,
          ignore_dirs = {
            "/.ccls-cache",
            "/build",
            "/node_modules",
            "/target",
          },
        },
      })
    end,
  },
}
