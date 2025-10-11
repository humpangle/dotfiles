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

-- Helper function to create description with count information
local function description_with_count(mapping_str)
  return string.format(
    " - count=index. 0=99 E.g. SPACE%s, [count]SPACE%s.",
    mapping_str,
    mapping_str
  )
end

-- Git stash list option
function M.git_stash_list_paginate()
  return {
    description = "Git stash list",
    action = function()
      git_stash_list_fn()()
    end,
  }
end

function M.git_stash_list_plain()
  return {
    description = "Git stash list plain",
    action = function()
      vim.cmd("G stash list")
    end,
  }
end

local stash_push = function(opts)
  return function()
    opts = opts or {}
    local left = "<left>"
    local left_repeated = left

    local cmd = "Git stash push "
    if opts.include_untracked then
      cmd = cmd .. "--include-untracked"
    elseif opts.all then
      cmd = cmd .. "--all"
    end

    cmd = cmd .. " -m ''" -- We will place cursor just before '

    if opts.current_file then
      local file_path = vim.fn.expand("%:p")
      file_path = utils.relative_to_git_root(file_path)

      local repeat_count = string.len(file_path) + 5
      left_repeated = ""

      for _ = 1, repeat_count do
        left_repeated = left_repeated .. left
      end

      cmd = cmd .. " -- " .. file_path
    end

    -- Move the cursor back by one position to place it after the commit hash and before the end quote
    vim.fn.feedkeys(
      ":"
        .. cmd
        .. vim.api.nvim_replace_termcodes(
          left_repeated,
          true,
          true,
          true
        ),
      "n"
    )
  end
end

function M.git_stash_push_current_file()
  return {
    description = "Git stash create/push current file",
    action = stash_push({ current_file = true }),
  }
end

function M.git_stash_push_include_untracked()
  return {
    description = "Git stash create/push include untracked",
    action = stash_push({ include_untracked = true }),
  }
end

function M.git_stash_push_all()
  return {
    description = "Git stash create/push ALL",
    action = stash_push({ all = true }),
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
        local cmd = ":Git stash "
          .. stash_action
          .. " --quiet "
          .. include_index
          .. "stash@{"
          .. position
          .. "}<Left>"

        vim.cmd(list_stash_cmd)

        vim.fn.feedkeys(
          vim.api.nvim_replace_termcodes(cmd, true, true, true),
          "n"
        )
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
