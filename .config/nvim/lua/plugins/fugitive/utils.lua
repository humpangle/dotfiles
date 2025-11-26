local M = {}
local utils = require("utils")

function M.highlight_text_under_cursor(text)
  local text_under_cursor = text or vim.fn.expand("<cword>")
  vim.fn.setreg("/", text_under_cursor)
  vim.cmd("set hlsearch")
  return text_under_cursor
end

function M.open_commit_under_cursor(split_cmd)
  local commit_ish = M.highlight_text_under_cursor(vim.fn.getreg(""))
  vim.cmd(split_cmd)
  vim.cmd("Gedit " .. commit_ish)
end

function M.get_git_commit(tree_ish)
  local git_tree_ish_head_list =
    vim.fn.systemlist("( cd " .. vim.fn.getcwd(0) .. " &&  git rev-parse " .. tree_ish .. " --short )")

  if #git_tree_ish_head_list == 1 then
    return git_tree_ish_head_list[1]
  elseif #git_tree_ish_head_list == 2 then
    return git_tree_ish_head_list[2]
  end

  return "ERROR"
end

function M.git_refresh_cwd()
  utils.handle_cant_re_enter_normal_mode_from_terminal_mode(function()
    vim.cmd("Git")
  end, {
    force = true,
    wipe = true,
  })
end

--- Checks if a buffer is a fugitive status buffer
--- @param bufnr number|nil Buffer number to check (defaults to current buffer)
--- @return boolean true if the buffer is a fugitive status buffer, false otherwise
function M.is_fugitive_status_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  -- Fugitive status buffers have the pattern: fugitive://<path>/.git//
  return bufname:match("^fugitive://.*%.git//$") ~= nil
end

return M
