local plugin_enabled = require("plugins/plugin_enabled")

if plugin_enabled.has_vscode() then
  return {}
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
      -- Optional image support in preview window: See `# Preview Mode` for more information
    not plugin_enabled.has_termux() and "3rd/image.nvim" or {},
  },
  init = function()
    local map_key = require("utils").map_key

    map_key("n", "\\", function()
      local count = vim.v.count

      if count == 0 then
        vim.cmd("Neotree source=filesystem position=left reveal")
        return
      end

      if count == 1 then
        vim.cmd("Neotree source=filesystem position=float reveal")
        return
      end

      if count == 2 then
        vim.cmd("Neotree source=buffers position=float")
        return
      end
    end, {
      desc = "Neotree --",
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
}
