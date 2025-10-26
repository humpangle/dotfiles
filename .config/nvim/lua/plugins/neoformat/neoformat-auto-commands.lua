local api = require("plugins.neoformat.neoformat-api")
local utils = require("utils")

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = api.file_patterns,
  callback = function()
    utils.map_key("n", "<leader>fc", api.do_format, {
      noremap = true,
      buffer = true,
    })
  end,
})
