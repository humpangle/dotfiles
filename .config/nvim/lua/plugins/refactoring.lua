local plugin_enabled = require("plugins/plugin_enabled")

if plugin_enabled.has_vscode() then
  return {}
end

local utils = require("utils")
local map_key = utils.map_key

return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  lazy = false,
  config = function()
    require("refactoring").setup({})

    map_key(
      { "n", "x" },
      "<leader>re",
      function()
        local count = vim.v.count

        if count == 0 then
          vim.cmd("Refactor extract ")
          return
        end

        if count == 1 then
          vim.cmd("Refactor extract_to_file ")
          return
        end

        if count == 2 then
          vim.cmd("Refactor extract_var ")
          return
        end

        if count == 3 then
          vim.cmd("Refactor inline_var")
          return
        end

        if count == 4 then
          vim.cmd("Refactor inline_func")
          return
        end

        if count == 5 then
          vim.cmd("Refactor extract_block")
          return
        end

        if count == 6 then
          vim.cmd("Refactor extract_block_to_file")
          return
        end
      end,
      {
        desc = "Refactor 0/extract 1/file 2/var 3/inline_var 4/func 5/block 6/block-to-file",
      }
    )
  end,
}
