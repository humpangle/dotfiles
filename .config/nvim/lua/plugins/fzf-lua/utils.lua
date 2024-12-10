local path = require("fzf-lua.path")
local utils = require("fzf-lua.utils")

local M = {}

M.git_branch_merge = function(selected, opts)
  local cmd_merge_branch = {
    "git",
    "merge",
  }
  local cmd_cur_branch = path.git_cwd({
    "git",
    "rev-parse",
    "--abbrev-ref",
    "HEAD",
  }, opts)

  local selected_branch = selected[1]:match("[^%s%*]+")

  local cur_branch = utils.io_systemlist(cmd_cur_branch)[1]

  if selected_branch == cur_branch then
    utils.warn(
      string.format(
        "Cannot merege branch '%s' into itself",
        selected_branch
      )
    )
    return
  end

  if
    vim.fn.confirm("Merge branch " .. selected_branch .. "?", "&Yes\n&No")
    == 1
  then
    table.insert(cmd_merge_branch, selected_branch)
    local output, rc = utils.io_systemlist(cmd_merge_branch)
    if rc ~= 0 then
      utils.err(unpack(output))
    else
      utils.info(unpack(output))
      vim.cmd("checktime")
    end
  end
end

return M
