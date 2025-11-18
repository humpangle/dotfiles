local utils = require("utils")

return {
  "mikavilpas/yazi.nvim",
  version = "*", -- use the latest stable version
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  keys = {
    utils.map_lazy_key("<Leader>vi", function()
      vim.o.background = "dark"
      local count = vim.v.count
      utils.handle_cant_re_enter_normal_mode_from_terminal_mode(function()
        if count == 0 then
          vim.cmd("Yazi")
        elseif count == 1 then
          vim.cmd("Yazi cwd")
        else
          vim.cmd("Yazi toggle")
        end
      end, {
        wipe = true,
      })
    end, { desc = "Open Yazi" }, { "n", "v" }),
  },
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false, -- false,
    keymaps = {
      show_help = "<f1>",
    },
  },
  -- 👇 if you use `open_for_directories=true`, this is recommended
  init = function()
    -- mark netrw as loaded so it's not loaded at all.
    --
    -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
    -- vim.g.loaded_netrwPlugin = 1
  end,
}
