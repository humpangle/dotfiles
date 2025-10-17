local M = {}
local utils = require("utils")

-- Helper function to check if there are any git stashes
local function has_git_stash()
  local handle = io.popen("git stash list")
  local result = nil

  if handle ~= nil then
    result = handle:read("*a")
    handle:close()
  end

  if not (result and result ~= "") then
    vim.cmd.echo('"No stashes found"')
    return false
  end

  return true
end

-- Helper function to create git stash list command with optional callback
local function git_stash_list_fn(callback)
  return function()
    if not has_git_stash() then
      return
    end

    local cmd =
      ":G --paginate stash list '--pretty=format:%h %as %<(10)%gd %<(76,trunc)%s'"

    if callback then
      callback(cmd)
    else
      vim.cmd(cmd)
    end
  end
end

M.git_stash_list_paginate = {
  description = "Git stash list",
  action = function()
    git_stash_list_fn()()
  end,
}

M.git_stash_list_plain = {
  description = "Git stash list plain",
  action = function()
    vim.cmd("G stash list")
  end,
}

for _, suffix in pairs({ "current_file", "all", "include_untracked" }) do
  local action = function()
    local left = "<left>"
    local left_repeated = left

    local cmd = "Git stash push "
    if suffix == "include_untracked" then
      cmd = cmd .. "--include-untracked"
    elseif suffix == "all" then
      cmd = cmd .. "--all"
    end

    cmd = cmd .. " -m ''" -- We will place cursor just between ''

    if suffix == "current_file" then
      local file_path = vim.fn.expand("%:p")
      file_path = utils.relative_to_git_root(file_path)

      local repeat_count = string.len(file_path) + 5
      left_repeated = ""

      for _ = 1, repeat_count do
        left_repeated = left_repeated .. left
      end

      cmd = cmd .. " -- " .. file_path
    end

    vim.fn.feedkeys(":" .. cmd .. vim.api.nvim_replace_termcodes(
      left_repeated, -- Move the cursor back to place it between ''
      true,
      true,
      true
    ), "n")
  end

  local props = "git_stash_push_" .. suffix

  local desc = ""
  if suffix == "include_untracked" then
    desc = "include untracked"
  elseif suffix == "current_file" then
    desc = "current_file"
  else
    desc = suffix
  end

  M[props] = {
    description = "Git stash create/push " .. desc,
    action = action,
  }
end

-- pop/apply
for _, stash_action in pairs({
  "drop",
  "pop",
  "apply",
}) do
  for _, position in pairs({ 0, "" }) do
    for _, include_index in pairs({ "--index", "" }) do
      local action = git_stash_list_fn(function(list_stash_cmd)
        vim.cmd(list_stash_cmd)

        vim.schedule(function()
          local cmd = "Git stash "
            .. stash_action
            .. " "
            .. include_index
            .. "stash@{"
            .. position
            .. "}<Left>"

          vim.fn.feedkeys(
            vim.api.nvim_replace_termcodes(cmd, true, true, true),
            "n"
          )
        end)
      end)

      local prop = "git_stash_"
        .. stash_action
        .. (include_index == "" and "" or "_index")
        .. (position == 0 and "_zero" or "")
      -- if stash_action == "drop" then
      --   vim.print("git_stash_shared_options." .. prop .. ",")
      -- end
      M[prop] = {
        description = "Git stash "
          .. stash_action
          .. (include_index == "" and "" or (" " .. include_index))
          .. (position == 0 and " 0" or ""),
        action = action,
      }
    end
  end
end

return M
