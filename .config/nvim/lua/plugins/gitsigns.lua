-- Inspired by
-- https://github.com/tpope/vim-fugitive/issues/1517
local function reload_fugitive_index()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local bufname = vim.api.nvim_buf_get_name(buf)
    if
      vim.startswith(bufname, "fugitive://")
      and string.find(bufname, ".git//0/")
    then
      vim.api.nvim_buf_call(buf, function()
        vim.cmd("edit! %") -- refresh the buffer
      end)
    end
  end
end

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

        utils.map_key({ "n", "v" }, "<leader>hs", function()
          if vim.fn.mode() == "v" then
            gitsigns.stage_hunk({
              vim.fn.line("."),
              vim.fn.line("v"),
            })
          else
            gitsigns.stage_hunk()
          end

          reload_fugitive_index()
        end, { desc = "Hunk stage" }, bufnr)

        utils.map_key("n", "<leader>hr", function()
          gitsigns.reset_hunk()
          reload_fugitive_index()
        end, { desc = "Hunk reset" }, bufnr)

        utils.map_key("n", "<leader>hS", function()
          vim.cmd(":Git add %")
          vim.cmd("edit! %")
          vim.cmd("redraw!")

          reload_fugitive_index()
          vim.cmd.echo("'" .. vim.fn.expand("%:.") .. " staged! '")
        end, { desc = "Hunk stage buffer" })

        utils.map_key("v", "<leader>hr", function()
          gitsigns.reset_hunk({
            vim.fn.line("."),
            vim.fn.line("v"),
          })

          reload_fugitive_index()
        end, { desc = "Hunk reset" }, bufnr)

        utils.map_key("n", "<leader>hu", function()
          gitsigns.undo_stage_hunk()

          reload_fugitive_index()
        end, { desc = "Hunk undo stage" }, bufnr)

        utils.map_key("n", "<leader>hR", function()
          gitsigns.reset_buffer()

          reload_fugitive_index()
        end, { desc = "Hunk reset buffer" }, bufnr)

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

        utils.map_key("n", "<leader>hp", function()
          local count = vim.v.count

          if count == 0 then
            gitsigns.preview_hunk()
          else
            gitsigns.preview_hunk_inline()
          end
        end, { desc = "Hunk preview 0/inline 1/" }, bufnr)

        utils.map_key("n", "<leader>hD", function()
          vim.cmd("edit! %")
          gitsigns.diffthis("~")
        end, { desc = "Hunk diffthis" }, bufnr)
      end,
    })
  end,
}
