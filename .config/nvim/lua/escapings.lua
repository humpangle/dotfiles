local utils = require("utils")

local escape_and_highlight = function(opts)
  local escaped = utils.escape_register_plus(opts.args)

  vim.fn.setreg("/", escaped)
  vim.o.hlsearch = true
  vim.cmd("normal! n")
end

local opts = {
  nargs = 1,
  complete = "file", -- optional: complete file paths
}

vim.api.nvim_create_user_command("HighlightEscape", escape_and_highlight, opts)
vim.api.nvim_create_user_command("EscapeHighlight", escape_and_highlight, opts)

vim.api.nvim_create_user_command("EscapeRegisterPlus", function()
  utils.escape_register_plus()
  vim.notify(vim.fn.getreg("+"))
end, {})

local function sanitize_filename()
  utils.sanitize_filename()
  vim.notify(vim.fn.getreg("+"))
end

vim.api.nvim_create_user_command("SanitizeFilename", function()
  sanitize_filename()
end, {})

vim.api.nvim_create_user_command("FilenameSanitize", function()
  sanitize_filename()
end, {})
