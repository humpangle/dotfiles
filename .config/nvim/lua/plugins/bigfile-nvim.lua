local plugin_enabled = require("plugins/plugin_enabled")

-- Improve performance of editing big files
return {
  -- https://github.com/LunarVim/bigfile.nvim
  "LunarVim/bigfile.nvim",
  event = "BufReadPre",
  enabled = plugin_enabled.has_big_file_nvim(),
  opts = {
    filesize = 2, -- size of the file in MiB, the plugin round file sizes to the closest MiB
    pattern = { "*" }, -- autocmd pattern or function see <### Overriding the detection of big files>
    features = { -- features to disable
      "indent_blankline", -- disables lukas-reineke/indent-blankline.nvim for the buffer
      "illuminate", -- disables RRethy/vim-illuminate for the buffer
      "lsp", -- detaches the lsp client from buffer
      "treesitter", -- disables treesitter for the buffer
      "syntax", -- :syntax off for the buffer
      "matchparen", -- :NoMatchParen globally, currently this feature will stay disabled, even after you close the big file
      "vimopts", -- swapfile = false foldmethod = "manual" undolevels = -1 undoreload = 0 list = false for the buffer
      "filetype", -- filetype = "" for the buffer
    },
  },
  config = function(_, opts)
    require("bigfile").setup(opts)
  end,
}
