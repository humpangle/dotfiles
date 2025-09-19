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

function M.get_git_commit(tree_ish)
  local git_tree_ish_head_list = vim.fn.systemlist(
    "( cd "
      .. vim.fn.getcwd(0)
      .. " &&  git rev-parse "
      .. tree_ish
      .. " --short )"
  )

  if #git_tree_ish_head_list == 1 then
    return git_tree_ish_head_list[1]
  elseif #git_tree_ish_head_list == 2 then
    return git_tree_ish_head_list[2]
  end

  return "ERROR"
end

return M
