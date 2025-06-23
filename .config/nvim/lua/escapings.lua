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

vim.api.nvim_create_user_command("DeAnsify", function()
  -- Use ansifilter to remove ANSI escape sequences
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local content = table.concat(lines, "\n")

  -- Create a temporary file with the buffer content
  local tmpfile = vim.fn.tempname()
  local outfile = vim.fn.tempname()

  -- Write content to temporary file
  local file = io.open(tmpfile, "w")
  if file then
    file:write(content)
    file:close()

    -- Run ansifilter command
    local cmd = string.format("ansifilter --text %s > %s", vim.fn.shellescape(tmpfile), vim.fn.shellescape(outfile))
    vim.fn.system(cmd)

    -- Read the filtered content
    local filtered_file = io.open(outfile, "r")
    if filtered_file then
      local filtered_content = filtered_file:read("*all")
      filtered_file:close()

      -- Replace buffer content with filtered text
      local filtered_lines = vim.split(filtered_content, "\n", { plain = true, trimempty = false })
      -- Remove the last empty line if it exists (common with file reading)
      if filtered_lines[#filtered_lines] == "" then
        table.remove(filtered_lines)
      end
      vim.api.nvim_buf_set_lines(0, 0, -1, false, filtered_lines)

      vim.notify("Buffer content filtered with ansifilter")
    else
      vim.notify("Failed to read filtered output", vim.log.levels.ERROR)
    end

    -- Clean up temporary files
    vim.fn.delete(tmpfile)
    vim.fn.delete(outfile)
  else
    vim.notify("Failed to create temporary file", vim.log.levels.ERROR)
  end
end, { desc = "Remove ANSI color codes using ansifilter command" })
