local M = {}

function M.highlight_text_under_cursor()
  local text_under_cursor = vim.fn.expand("<cword>")
  vim.fn.setreg("/", text_under_cursor)
  vim.cmd("set hlsearch")
  return text_under_cursor
end

function M.open_commit_under_cursor(split_cmd)
  local commit_ish = M.highlight_text_under_cursor()
  vim.cmd(split_cmd)
  vim.cmd("Gedit " .. commit_ish)
end

return M
