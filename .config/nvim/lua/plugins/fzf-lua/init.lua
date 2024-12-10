local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.fzf_lua_install() then
  return {}
end

local utils = require("utils")
local map_key = utils.map_key

return {
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      vim.cmd("FzfLua register_ui_select")

      local actions = require("fzf-lua.actions")
      local my_fzf_utils = require("plugins/fzf-lua/utils")

      require("fzf-lua").setup({
        winopts = {
          fullscreen = true,
        },

        git = {
          branches = {
            actions = {
              ["enter"] = actions.git_switch,

              ["ctrl-d"] = {
                fn = actions.git_branch_del,
                reload = true,
              },

              ["ctrl-b"] = {
                fn = actions.git_branch_add,
                field_index = "{q}",
                reload = true,
              },

              ["ctrl-e"] = {
                fn = my_fzf_utils.git_branch_merge,
                -- reload = true,
              },
            },
            -- Add branch and switch immediately
            cmd_add = {
              "git",
              "checkout",
              "-b",
            },
          },
        },
      })

      -- Find open buffers
      map_key("n", "<Leader>ffb", function()
        vim.cmd("FzfLua buffers")
      end, {
        noremap = true,
      })

      -- Find file from cwd
      map_key("n", "<leader>ffW", function()
        vim.cmd("FzfLua files")
      end, { noremap = true })

      -- Find windows
      map_key("n", "<leader>ffw", function()
        vim.cmd("FzfLua tabs")
      end, { noremap = true })

      -- Search buffers history
      map_key("n", "<Leader>fh", function()
        vim.cmd("FzfLua oldfiles")
      end, {
        noremap = true,
      })

      -- Search for text in current buffer
      map_key("n", "<Leader>ffl", function()
        vim.cmd("FzfLua grep_curbuf")
      end, {
        noremap = true,
        desc = "",
      })

      -- Search in project - do not match filenames
      map_key("n", "<Leader>f/", function()
        vim.cmd("FzfLua grep_project")
      end, { noremap = true })

      -- map_key("n", "<leader>cb", function()
      --   vim.cmd("FzfLua git_branches")
      -- end, {
      --   noremap = true,
      --   desc = "Git branches",
      -- })

      map_key("n", "<leader>czL", function()
        vim.cmd("FzfLua git_stash")
      end, {
        noremap = true,
        desc = "Git stashes list",
      })

      map_key("n", "<leader>bs", function()
        vim.cmd("FzfLua lsp_document_symbols")
      end, {
        noremap = true,
        desc = "LSP buffer symbols",
      })

      map_key("n", "<leader>gr", function()
        vim.cmd("FzfLua lsp_references")
      end, {
        noremap = true,
        desc = "LSP Symbol Under Cursor References",
      })

      map_key("n", "<leader>ws", function()
        -- vim.cmd("FzfLua lsp_workspace_symbols")
        vim.cmd("FzfLua lsp_live_workspace_symbols")
      end, {
        noremap = true,
        desc = "LSP workspace symbols",
      })
    end,
  },
}
