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

-- Helper function for git stash apply or pop operations
local function git_stash_apply_or_pop(apply_or_pop, maybe_include_index)
  return git_stash_list_fn(function(list_stash_cmd)
    local count = vim.v.count

    local cmd = ":Git stash "
      .. apply_or_pop
      .. " --quiet "
      .. (maybe_include_index and "--index " or "")
      .. "stash@{"
      .. (count == 99 and 0 or (count > 0 and count or "")) -- Count 99 simulates count 0 (See czd -->> git stash drop).
      .. "}<Left>"

    if count < 1 then -- No count given.
      vim.cmd(list_stash_cmd)
    end

    vim.fn.feedkeys(
      vim.api.nvim_replace_termcodes(cmd, true, true, true),
      "n"
    )
  end)
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

-- Git stash drop option
function M.git_stash_drop()
  return {
    description = "Git stash drop" .. description_with_count("drop"),
    action = git_stash_list_fn(function(list_stash_cmd)
      local cmd = ":G stash drop stash@{}<left>"

      local count = vim.v.count

      -- Unfortunately, vim.v.count will return '0' if no count given. We simulate count 0 using 99 (we assume we cannot
      -- have git stash index 99).
      if count == 99 then -- simulate count 0
        cmd = ":G stash drop stash@{0}<Left>"
      elseif count > 0 then -- count given (not 0)
        cmd = ":G stash drop stash@{" .. count .. "}<Left>"
      else -- no count
        -- List stashes so we can select count
        vim.cmd(list_stash_cmd)
      end

      vim.fn.feedkeys(
        vim.api.nvim_replace_termcodes(cmd, true, true, true),
        "t"
      )
    end),
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

-- Git stash pop option
function M.git_stash_pop()
  return {
    description = "Git stash pop 0",
    action = git_stash_apply_or_pop("pop"),
  }
end

-- Git stash pop --index option
function M.git_stash_pop_index()
  return {
    description = "Git stash pop --index"
      .. description_with_count("pop-index"),
    action = git_stash_apply_or_pop("pop", "index"),
  }
end

-- Git stash apply option
function M.git_stash_apply()
  return {
    description = "Git stash apply" .. description_with_count("apply"),
    action = git_stash_apply_or_pop("apply"),
  }
end

-- Git stash apply --index option
function M.git_stash_apply_index()
  return {
    description = "Git stash apply --index"
      .. description_with_count("apply-index"),
    action = git_stash_apply_or_pop("apply", "index"),
  }
end

return M
