return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- Optional image support in preview window: See `# Preview Mode` for more information
      -- "3rd/image.nvim"
    },
    init = function()
      local map_key = require("utils").map_key
      local utils = require("utils")

      local neotree_options = {
        {
          description = "Filesystem float                 1",
          action = function()
            vim.cmd(
              "Neotree source=filesystem position=float reveal"
            )
          end,
          count = 1,
        },
        -- {
        --   description = "Filesystem current               11",
        --   action = function()
        --     vim.cmd("Neotree source=filesystem position=current reveal")
        --   end,
        --   count = 11,
        -- },
        {
          description = "Filesystem left                  2",
          action = function()
            vim.cmd(
              "Neotree source=filesystem position=left reveal"
            )
          end,
          count = 2,
        },
        {
          description = "Filesystem tab                   3",
          action = function()
            vim.cmd("tab split")
            vim.cmd(
              "Neotree source=filesystem position=current reveal"
            )
            vim.cmd("-tabmove")
          end,
          count = 3,
        },
        {
          description = "Filesystem first tab             4",
          action = function()
            vim.cmd("tab split")
            vim.cmd(
              "Neotree source=filesystem position=current reveal"
            )
            vim.cmd("0tabmove")
          end,
          count = 4,
        },
        {
          description = "Buffers float                    5",
          action = function()
            vim.cmd("Neotree source=buffers position=float")
          end,
          count = 5,
        },
      }

      map_key("n", "\\", function()
        local fzf_lua = require("fzf-lua")
        local keymap_count = vim.v.count

        local items = {}
        for i, option in ipairs(neotree_options) do
          -- Check if count matches any action
          if keymap_count == option.count then
            option.action()
            return
          end

          -- If no count match, show FZF menu
          table.insert(
            items,
            string.format("%d. %s", i, option.description)
          )
        end

        -- utils.set_fzf_lua_nvim_listen_address()

        fzf_lua.fzf_exec(items, {
          prompt = "Neotree Options> ",
          actions = {
            ["default"] = function(selected)
              if not selected or #selected == 0 then
                return
              end

              local selection = selected[1]
              -- Extract option index from selection
              local index = tonumber(selection:match("^(%d+)%."))
              if index and neotree_options[index] then
                neotree_options[index].action()
              end
            end,
          },
          fzf_opts = {
            ["--no-multi"] = "",
            ["--header"] = "Select a neotree option",
          },
        })
      end, {
        desc = "Neotree 0/float 1/buffers 2/left 3/tab",
      })
    end,
    config = function()
      -- If you want icons for diagnostic errors, you'll need to define them somewhere:
      vim.fn.sign_define(
        "DiagnosticSignError",
        { text = " ", texthl = "DiagnosticSignError" }
      )
      vim.fn.sign_define(
        "DiagnosticSignWarn",
        { text = " ", texthl = "DiagnosticSignWarn" }
      )
      vim.fn.sign_define(
        "DiagnosticSignInfo",
        { text = " ", texthl = "DiagnosticSignInfo" }
      )
      vim.fn.sign_define(
        "DiagnosticSignHint",
        { text = "󰌵", texthl = "DiagnosticSignHint" }
      )

      local neotree = require("neo-tree")
      local helpers = require("plugins.neotree.helpers")

      neotree.setup(helpers.config)
    end,
  },
  {
    -- If we stop using neotree, we need to find another filetree plugin
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
}
