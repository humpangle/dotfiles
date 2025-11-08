local M = {}

-- Custom action to force delete git branch with -D option
M.git_branch_force_del = function(selected, opts)
  local path = require("fzf-lua.path")
  local utils = require("fzf-lua.utils")

  if #selected == 0 then
    return
  end
  ---@type string[]
  local cmd_del_branch = path.git_cwd({ "git", "branch", "-D" }, opts)
  ---@type string[]
  local cmd_cur_branch =
    path.git_cwd({ "git", "rev-parse", "--abbrev-ref", "HEAD" }, opts)
  local branch = selected[1]:match("^[%*+]*[%s]*[(]?([^%s)]+)")
  local cur_branch_result = utils.io_systemlist(cmd_cur_branch)
  local cur_branch = cur_branch_result[1]
  if branch == cur_branch then
    utils.warn("Cannot delete active branch '%s'", branch)
    return
  end
  if
    vim.fn.confirm("Force delete branch " .. branch .. "?", "&Yes\n&No")
    == 1
  then
    table.insert(cmd_del_branch, branch)
    local output, rc = utils.io_systemlist(cmd_del_branch)
    if rc ~= 0 then
      utils.error(unpack(output))
    else
      utils.info(unpack(output))
    end
  end
end

return M
