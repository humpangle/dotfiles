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
  local cmd_cur_branch = path.git_cwd({ "git", "rev-parse", "--abbrev-ref", "HEAD" }, opts)
  local branch = selected[1]:match("^[%*+]*[%s]*[(]?([^%s)]+)")
  local cur_branch_result = utils.io_systemlist(cmd_cur_branch)
  local cur_branch = cur_branch_result[1]
  if branch == cur_branch then
    utils.warn("Cannot delete active branch '%s'", branch)
    return
  end
  if vim.fn.confirm("Force delete branch " .. branch .. "?", "&Yes\n&No") == 1 then
    table.insert(cmd_del_branch, branch)
    local output, rc = utils.io_systemlist(cmd_del_branch)
    if rc ~= 0 then
      utils.error(unpack(output))
    else
      utils.info(unpack(output))
    end
  end
end

-- Custom action to rename/move git worktree
M.git_worktree_rename = function(selected)
  local path = require("fzf-lua.path")
  local utils = require("fzf-lua.utils")

  if #selected == 0 then
    return
  end

  local worktree_path = selected[1]:match("^[^%s]+")
  local current_cwd = vim.uv.cwd()

  if worktree_path == current_cwd or path.normalize(worktree_path) == path.normalize(current_cwd) then
    utils.warn("Cannot rename current worktree '%s'", worktree_path)
    return
  end

  -- Extract current worktree name from path
  local current_name = vim.fn.fnamemodify(worktree_path, ":t")

  -- Prompt for new name
  local new_name = vim.fn.input({
    prompt = "Rename worktree '" .. current_name .. "' to: ",
    default = current_name,
  })

  if not new_name or new_name == "" or new_name == current_name then
    utils.info("Rename cancelled")
    return
  end

  -- Execute _git rename-worktree command
  local cmd = {
    "_git",
    "rename-worktree",
    "-w",
    worktree_path,
    "-n",
    new_name,
  }

  local output, rc = utils.io_systemlist(cmd)

  if rc ~= 0 then
    utils.error(unpack(output))
    vim.print(output)
  else
    utils.info("Renamed worktree '%s' to '%s'", current_name, new_name)
  end
end

-- Custom action to copy git worktree path to clipboard
M.git_worktree_copy = function(selected)
  local utils = require("fzf-lua.utils")

  if #selected == 0 then
    return
  end

  local worktree_path = selected[1]:match("^[^%s]+")

  -- Copy path to system clipboard
  vim.fn.setreg("+", worktree_path)
  vim.print(worktree_path)
  utils.info("Copied worktree path to clipboard: %s", worktree_path)
end

return M
