local utils_status_ok, utils = pcall(require, "utils")
if not utils_status_ok then
  return
end

local keymap = utils.map_key

keymap("n", "<leader>g.", ":Git add .<CR>", { noremap = true })
keymap("n", "<leader>gd", ":Gvdiffsplit!<CR>", { noremap = true })

keymap("n", "<leader>gf", function()
  utils.write_to_command_mode(
    "Git push --force-with-lease origin " .. vim.fn.FugitiveHead()
  )
end, { noremap = true })

keymap(
  "n",
  "<leader>gF",
  ":Git push --force-with-lease github HEAD<CR>",
  { noremap = true }
)

keymap("n", "<leader>go", function()
  utils.write_to_command_mode("Git push origin " .. vim.fn.FugitiveHead())
end, { noremap = true })

-- gt = git take / pull
keymap("n", "<leader>gt", function()
  vim.cmd("Git fetch")

  utils.write_to_command_mode("Git pull origin " .. vim.fn.FugitiveHead())
end, { noremap = true })

-- Git stash related mappings

-- Git stash list inspired by
--   https://github.com/tpope/vim-fugitive/issues/236#issuecomment-1737935479
local has_git_stash = function()
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

local git_stash_list_fn = function(callback)
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

keymap("n", "<Leader>czl", function()
  local count = vim.v.count

  if count == 0 then
    if has_git_stash() then
      vim.cmd("G stash list")
    end
    return
  end

  git_stash_list_fn()()
end, { noremap = true, silent = true, desc = "Git stash list" })

local description_with_count = function(mapping_str)
  return string.format(
    " - count=index. 0=99 E.g. SPACE%s, [count]SPACE%s.",
    mapping_str,
    mapping_str
  )
end

keymap(
  "n",
  "<Leader>czd",
  git_stash_list_fn(function(list_stash_cmd)
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
  { noremap = true, desc = "Git stash drop" .. description_with_count("czd") }
)

keymap("n", "<Leader>czz", function()
  -- Get the latest Git commit hash
  local latest_commit = vim.fn.systemlist("git rev-parse --short HEAD")[1]

  local count = vim.v.count
  local cmd = "Git stash push"
  local current_file_only = false

  if count == 1 then
    cmd = cmd
  elseif count == 2 then
    cmd = cmd .. " --include-untracked"
  elseif count == 3 then
    cmd = cmd .. " --all"
  elseif count == 4 then
    current_file_only = true
  else
    vim.cmd.echo(
      '"count should be 1/plain 2/--include-untracked 3/--all 4/pathspec"'
    )
    return
  end

  -- Append text for custom message with the latest commit hash and place cursor between quotes
  cmd = cmd .. " -m '" .. latest_commit .. ": '"

  local left = "<left>"
  local left_repeated_severally = left

  if current_file_only then
    local file_path = vim.fn.expand("%:.")
    local how_many_times_to_repeat = string.len(file_path) + 5

    left_repeated_severally = ""

    ---@diagnostic disable-next-line: unused-local
    for i = 1, how_many_times_to_repeat do
      left_repeated_severally = left_repeated_severally .. left
    end

    cmd = cmd .. " -- " .. file_path
  end

  -- Move the cursor back by one position to place it after the commit hash and before the end quote
  vim.fn.feedkeys(
    ":"
      .. cmd
      .. vim.api.nvim_replace_termcodes(
        left_repeated_severally,
        true,
        true,
        true
      ),
    "t"
  )
end, {
  noremap = true,
  desc = "G stash push --include-untracked/--all -m 'GITHEAD: '",
})

local git_stash_apply_or_pop = function(apply_or_pop, maybe_include_index)
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
      "t"
    )
  end)
end

keymap("n", "<Leader>czP", git_stash_apply_or_pop("pop"), {
  noremap = true,
  desc = "Git stash pop" .. description_with_count("czP"),
})

keymap("n", "<Leader>czp", git_stash_apply_or_pop("pop", "index"), {
  noremap = true,
  desc = "Git stash pop --index" .. description_with_count("czp"),
})

keymap("n", "<Leader>czA", git_stash_apply_or_pop("apply"), {
  noremap = true,
  desc = "Git stash apply" .. description_with_count("czA"),
})

keymap("n", "<Leader>cza", git_stash_apply_or_pop("apply", "index"), {
  noremap = true,
  desc = "Git stash apply --index" .. description_with_count("cza"),
})
-- END Git stash related mappings

-- Git commit mappings
local git_commit_mappings_fn = function()
  local count = vim.v.count

  if count == 0 then
    vim.cmd("Git commit")
    return
  end

  local cmd = nil

  if count == 1 then
    cmd = "--allow-empty"
  elseif count == 2 then
    cmd = "--amend"
  elseif count == 3 then
    cmd = "--amend --no-edit"
  elseif count == 4 then
    utils.write_to_command_mode(
      "G verify-commit -v " .. vim.fn.expand("<cword>") .. " "
    )
    return
  elseif count == 41 then
    utils.write_to_command_mode(
      "G verify-commit " .. vim.fn.expand("<cword>") .. " "
    )
    return
  elseif count == 5 then
    utils.write_to_command_mode("G verify-commit ")
    return
  elseif count == 51 then
    utils.write_to_command_mode("G verify-commit -v ")
    return
  else
    cmd = ""
  end

  utils.write_to_command_mode("Git commit " .. cmd)
end
local git_commit_mappings_opts = {
  noremap = true,
  desc = "Git commit 1/empty 2/amend 3/amendNoEdit 4/verify",
}
keymap("n", "<leader>gc", git_commit_mappings_fn, git_commit_mappings_opts)

-- Git config.user
keymap("n", "<leader>gu", function()
  local cmd = ""
  local count = vim.v.count

  if count == 0 then
    cmd = ":Git config user.name <right>"
  elseif count == 1 then
    cmd = ":Git config user.email <right>"
  elseif count == 2 then
    local git_user = utils.get_os_env_or_nil("GIT_USER")

    local git_user_email = utils.get_os_env_or_nil("GIT_USER_EMAIL")

    if git_user ~= nil and git_user_email ~= nil then
      cmd = ":Git config user.name "
        .. git_user
        .. "<bar>"
        .. ":Git config user.email "
        .. git_user_email
    end
  end

  if cmd == "" then
    vim.cmd.echo(
      '"We can not set git user/email.Set GIT_USER/GIT_USER_EMAIL Aborting!"'
    )
    return
  end

  vim.fn.feedkeys(vim.api.nvim_replace_termcodes(cmd, true, true, true), "t")
end, { noremap = true, desc = "Git config user name. 1=email 2=env defaults" })

-- Rebase keymaps
local git_rebase_root_mappings_fn = function()
  local count = vim.v.count

  if count == 1 then
    utils.write_to_command_mode("G rebase -i --root")
  elseif count == 2 then
    utils.write_to_command_mode("G reset --soft ")
  elseif count == 3 then
    utils.write_to_command_mode("G reset --hard ")
  else
    utils.write_to_command_mode("G rebase -i ")
  end
end
local git_rebase_root_mappings_desc = [[G rebase 1/root 2/soft 3/hard]]
keymap("n", "<Leader>r<Space>", git_rebase_root_mappings_fn, {
  noremap = true,
  desc = git_rebase_root_mappings_desc,
})

keymap("n", "<Leader>rr", function()
  utils.write_to_command_mode("G rebase --continue")
end, { noremap = true, desc = [[Continue the current rebase.]] })

keymap("n", "<Leader>ra", function()
  utils.write_to_command_mode("G rebase --abort")
end, { noremap = true, desc = [[Abort the current rebase.]] })

keymap("n", "<Leader>re", function()
  utils.write_to_command_mode("G rebase --edit-todo")
end, { noremap = true, desc = [[Edit the current rebase todo list.]] })
-- /END Rebase keymaps

-- Git mappings
keymap("n", "<leader>gg", function()
  local count = vim.v.count

  if count == 0 then
    vim.cmd("Git")
    print("Git refreshed!")
    return
  end

  if count == 1 then
    vim.cmd("Git log --oneline")
    return
  end

  if count == 11 then
    vim.cmd("Git log")
    return
  end

  if count == 2 then
    vim.cmd("Git log --oneline -- %")
    return
  end

  if count == 22 then
    vim.cmd("Git log -- %")
    return
  end

  if count == 23 then
    vim.cmd("only")
    vim.cmd("0GcLog!")
    vim.cmd("vsplit")
    vim.cmd("diffthis")
    vim.cmd("wincmd h")
    return
  end

  if count == 3 then
    utils.write_to_command_mode("Git log --oneline -")
  end
end, {
  noremap = true,
  desc = "Git commit 1/all 2/file% 3/all-",
})

-- git blame
keymap("n", "<leader>gb", function()
  vim.cmd("Git blame")
end, { desc = "G blame" })

-- Auto-clean Fugitive Buffers
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "fugitive://*",
  callback = function()
    vim.opt_local.bufhidden = "delete"
  end,
})

-- http://vimcasts.org/episodes/fugitive-vim-browsing-the-git-object-database/
-- Fugitive Browsing Git Object Database
vim.api.nvim_create_autocmd("User", {
  pattern = "fugitive",
  callback = function()
    vim.cmd([[
        if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
          keymap("n", "<buffer> .. :edit %:h<CR> |
        endif
      ]])
  end,
})

--  Remapping in Gitcommit FileType
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    keymap("n", "<leader>wq", utils.ebnis_save_commit_buffer, {
      noremap = true,
      buffer = true,
    })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "fugitive",
  callback = function()
    keymap("n", "cc", git_commit_mappings_fn, {
      buffer = true,
      noremap = true,
      desc = "Git commit 1/empty 2/amend 3/amendNoEdit",
    })

    keymap("n", "r<space>", git_rebase_root_mappings_fn, {
      buffer = true,
      noremap = true,
      desc = git_rebase_root_mappings_desc,
    })
  end,
})

vim.g.fugitive_summary_format = "%d %s"
