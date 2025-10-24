local m = {}

for _, branch_name in pairs({ "main", "master", "develop" }) do
  local action = function()
    local path = vim.fn.systemlist(
      "_git get-worktree-path-for-branch " .. branch_name
    )[1]

    if not path or path == "" then
      vim.notify(
        "Branch " .. branch_name .. " does not exist",
        vim.log.levels.ERROR
      )
      return
    end

    local cmd = {
      "(\n",
      "cd " .. path,
      "&& \n",
      "git fetch",
      "&& \n",
      "git pull origin " .. branch_name,
      "&& \n",
      "git submodule update --init --recursive",
      "\n)",
    }

    local cmd_str = table.concat(cmd, " ")

    local result = vim.fn.systemlist(cmd_str)
    vim.print(
      "\nPulling branch "
        .. branch_name
        .. ":\n"
        .. table.concat(result, "\n")
        .. "\n"
    )
  end

  local prop = "pull_branch_" .. branch_name
  m[prop] = {
    description = "Git pull/fetch branch " .. branch_name,
    action = action,
  }
end

return m
