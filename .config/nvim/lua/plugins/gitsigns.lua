-- Inspired by
-- https://github.com/tpope/vim-fugitive/issues/1517
local function reload_fugitive_index()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local bufname = vim.api.nvim_buf_get_name(buf)
    if
      vim.startswith(bufname, "fugitive://")
      and (
        vim.endswith(bufname, ".git//")
        or vim.endswith(bufname, vim.fn.expand("%:r"))
      )
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
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      },
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
          local count = vim.v.count
          local mode = vim.fn.mode() == "v"

          if count == 0 then
            if mode then
              gitsigns.stage_hunk({
                vim.fn.line("."),
                vim.fn.line("v"),
              })
            else
              gitsigns.stage_hunk()
            end
          elseif count == 1 then
            vim.cmd(":Git add %")
            vim.cmd("edit! %")
            vim.cmd("redraw!")
          elseif count == 2 then
            if mode == "v" then
              gitsigns.reset_hunk({
                vim.fn.line("."),
                vim.fn.line("v"),
              })
            else
              gitsigns.reset_hunk()
            end
          elseif count == 22 then
            gitsigns.reset_buffer()
          end

          reload_fugitive_index()
          vim.cmd.echo("'" .. vim.fn.expand("%:.") .. " staged! '")
        end, {
          desc = "Stage 0/partial 1/full 2/undo",
        }, bufnr)

        utils.map_key("n", "<leader>hb", function()
          local count = vim.v.count

          if count == 0 then
            gitsigns.blame_line({ full = true })
          else
            -- Show blame information for the current line in virtual text.
            gitsigns.toggle_current_line_blame()
          end
        end, { desc = "Hunk blame line" }, bufnr)

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
