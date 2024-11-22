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
          vim.cmd("NvimTreeOpen " .. vim.fn.getcwd())
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
        hijack_netrw = false,

        view = {
          width = 60,
          number = true,
          relativenumber = true,
        },

        renderer = {
          icons = {
            show = {
              diagnostics = false,
              git = false,
            },
          },
        },

        filters = {
          enable = false,
        },

        filesystem_watchers = {
          enable = false,
        },

        actions = {
          change_dir = {
            -- Change the working directory when changing directories in the tree.
            enable = false,
            -- Use `:cd` instead of `:lcd` when changing directories.
            -- Consider that this might cause issues with the
            global = false,
            -- Restrict changing to a directory above the global cwd.
            restrict_above_cwd = false,
          },
        },

        git = {
          enable = false,
        },

        diagnostics = {
          enable = false,
        },
      })
    end,
  },
}
