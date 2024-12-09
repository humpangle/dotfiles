local plugin_enabled = require("plugins/plugin_enabled")

if not plugin_enabled.has_big_file_nvim() then
  return {}
end

-- Improve performance of editing big files
return {
  -- https://github.com/LunarVim/bigfile.nvim
  "LunarVim/bigfile.nvim",
  event = "BufReadPre",
  priority = 10000,
  opts = {
    filesize = 1.5, -- size of the file in MiB, the plugin round file sizes to the closest MiB
    features = { -- features to disable
      "lsp", -- detaches the lsp client from buffer
      "treesitter", -- disables treesitter for the buffer
      "illuminate", -- disables RRethy/vim-illuminate for the buffer
      "indent_blankline", -- disables lukas-reineke/indent-blankline.nvim for the buffer
      "syntax", -- :syntax off for the buffer
      "filetype", -- filetype = "" for the buffer
      "vimopts", -- swapfile = false foldmethod = "manual" undolevels = -1 undoreload = 0 list = false for the buffer
      "matchparen", -- :NoMatchParen globally, currently this feature will stay disabled, even after you close the big file
    },
  },
  config = function(_, opts)
    -- https://github.com/LunarVim/bigfile.nvim#overriding-the-detection-of-big-files
    opts.pattern = function(bufnr)
      local filename = vim.api.nvim_buf_get_name(bufnr)

      if filename:sub(-4) == ".log" then
        vim.api.nvim_buf_set_option(bufnr, "backupcopy", "yes")
        return true
      end

      return false
    end

    require("bigfile").setup(opts)
  end,
}
