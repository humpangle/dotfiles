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
  cmd = {
    "Octo",
  },
  keys = {
    map_lazy_key("<leader>ghh", function()
      vim.cmd("Octo")
    end, { desc = "Octo" }),

    map_lazy_key("<leader>gh0", function()
      if vim.bo.filetype == "octo" then
        vim.bo.filetype = "markdown"
      else
        vim.bo.filetype = "octo"
      end
    end, { desc = "0/toggleFileType octo->markdown" }),

    map_lazy_key("<leader>ghp", function() -- pull request
      local count = vim.v.count

      if count == 0 then
        vim.cmd("Octo pr create")
        return
      end

      if count == 1 then
        vim.cmd("Octo pr checkout")
        return
      end

      if count == 2 then
        utils.write_to_command_mode("Octo pr close")
        return
      end

      if count == 3 then
        vim.cmd("Octo pr url")
        vim.notify("PR URL: " .. vim.fn.getreg("+"))
        return
      end

      if count == 31 then
        vim.cmd("Octo pr browser")
        vim.notify("PR URL: " .. vim.fn.getreg("+"))
        return
      end

      if count == 4 then
        vim.cmd("Octo pr reload")
        return
      end

      if count == 5 then
        vim.cmd("tab split")
        vim.cmd("Octo pr list")
        return
      end
    end, {
      desc = "Octo PR 0/create 1/checkout 2/close 3/url 31/browser 4/reload 5/list",
    }),

    map_lazy_key("<leader>ghr", function() -- review
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
        vim.cmd("Octo review close")
      end

      if count == 3 then
        vim.cmd("Octo review submit")
        return
      end

      if count == 33 then
        vim.cmd("Octo review resume")

        vim.defer_fn(function()
          vim.cmd("Octo review submit")
        end, 4000)

        return
      end
    end, { desc = "Octo Review 0/start 1/resume 2/close 3/submit" }),

    map_lazy_key(
      "<leader>ghc",
      function() -- comment
        local count = vim.v.count

        if count == 0 then
          vim.cmd("Octo comment add")
          return
        end

        if count == 1 then
          vim.cmd("Octo comment suggest")
          return
        end

        if count == 2 then
          vim.cmd("Octo comment delete")
          return
        end

        if count == 3 then
          vim.cmd("Octo comment url")
          return
        end

        if count == 4 then
          require("octo.navigation").next_comment()
          return
        end

        if count == 44 then
          require("octo.navigation").prev_comment()
          return
        end
      end,
      { desc = "Octo Comment 0/add 1/suggest 2/delete 3/url 44/nextPrev" }
    ),

    map_lazy_key("<leader>ghx", function() -- reaction
      local count = vim.v.count

      if count == 0 then
        vim.cmd("Octo reaction thumbs_up")
        return
      end

      if count == 1 then
        vim.cmd("Octo reaction eyes")
        return
      end

      if count == 2 then
        vim.cmd("Octo reaction thumbs_down")
        return
      end

      if count == 3 then
        vim.cmd("Octo reaction heart")
        return
      end

      if count == 4 then
        vim.cmd("Octo reaction laugh")
        return
      end
    end, { desc = "Octo Reaction 0/up 1/eyes 2/down 3/heart 4/laugh" }),
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
