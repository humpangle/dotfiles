return {
  "lewis6991/gitsigns.nvim",
  config = function()
    local gitsigns = require("gitsigns")

    gitsigns.setup({
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },

      on_attach = function(bufnr)
        local utils = require("utils")

        -- Navigation
        utils.map_key("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, { desc = "Hunk next." })

        utils.map_key("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, { desc = "Hunk previous." })
        -- / Navigation

        utils.map_key("n", "<leader>hs", function()
          gitsigns.stage_hunk()
          vim.cmd("edit! %")
        end, { desc = "Hunk stage" }, bufnr)

        utils.map_key("n", "<leader>hr", function()
          gitsigns.reset_hunk()
          vim.cmd("edit! %")
        end, { desc = "Hunk reset" }, bufnr)

        utils.map_key("v", "<leader>hs", function()
          gitsigns.stage_hunk({
            vim.fn.line("."),
            vim.fn.line("v"),
          })

          vim.cmd("edit! %")
        end, { desc = "Hunk stage" }, bufnr)

        utils.map_key("v", "<leader>hr", function()
          gitsigns.reset_hunk({
            vim.fn.line("."),
            vim.fn.line("v"),
          })
        end, { desc = "Hunk reset" }, bufnr)

        utils.map_key("n", "<leader>hS", function()
          vim.cmd(":Git add %")
          vim.cmd("edit! %")
          vim.cmd("redraw!")
          vim.cmd.echo("'" .. vim.fn.expand("%:.") .. " staged! '")
        end, { desc = "Hunk stage buffer" })

        utils.map_key("n", "<leader>hu", function()
          gitsigns.undo_stage_hunk()
          vim.cmd("edit! %")
        end, { desc = "Hunk undo stage" }, bufnr)

        utils.map_key("n", "<leader>hR", function()
          gitsigns.reset_buffer()
          vim.cmd("edit! %")
        end, { desc = "Hunk reset buffer" }, bufnr)

        utils.map_key(
          "n",
          "<leader>hp",
          gitsigns.preview_hunk,
          { desc = "Hunk preview" },
          bufnr
        )

        utils.map_key("n", "<leader>hb", function()
          gitsigns.blame_line({ full = true })
        end, { desc = "Hunk blame line" }, bufnr)

        utils.map_key(
          "n",
          "<leader>tb",
          gitsigns.toggle_current_line_blame,
          { desc = "Hunk toggle current line blame" },
          bufnr
        )

        utils.map_key("n", "<leader>hD", function()
          vim.cmd("edit! %")
          gitsigns.diffthis("~")
        end, { desc = "Hunk diffthis" }, bufnr)
      end,
    })
  end,
}
