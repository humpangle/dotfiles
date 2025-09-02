local utils_status_ok, utils = pcall(require, "utils")
if not utils_status_ok then
  return
end

local keymap = utils.map_key

keymap("n", "<leader>g.", ":Git add .<CR>", { noremap = true })
keymap("n", "<leader>gd", function()
  local count = vim.v.count

  if count == 0 then
    vim.cmd("Gvdiffsplit!")
    return
  end

  if count == 1 then
    vim.cmd("Ghdiffsplit!")
    return
  end
end, {
  noremap = true,
  desc = "0/v 1/h",
})

keymap("n", "<leader>gp", function()
  local count = vim.v.count
  if count == 0 then
    utils.write_to_command_mode("Git push origin " .. vim.fn.FugitiveHead())
    return
  end

  if count == 1 then
    utils.write_to_command_mode(
      "Git push --force-with-lease origin " .. vim.fn.FugitiveHead()
    )
    return
  end
end, { noremap = true, desc = "Git push 0/ 1/force" })

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
    git_stash_list_fn()()
    return
  end

  if has_git_stash() then
    vim.cmd("G stash list")
  end
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
  cmd = cmd
    .. " -m '"
    .. latest_commit
    .. " "
    .. vim.fn.FugitiveHead()
    .. ": '"

  local left = "<left>"
  local left_repeated_severally = left

  if current_file_only then
    local file_path = vim.fn.expand("%:p")
    file_path = utils.relative_to_git_root(file_path)
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

local function highlight_text_under_cursor()
  local text_under_cursor = vim.fn.expand("<cword>")
  vim.fn.setreg("/", text_under_cursor)
  vim.cmd("set hlsearch")
  return text_under_cursor
end

local function open_commit_under_cursor(split_cmd)
  local commit_ish = highlight_text_under_cursor()
  vim.cmd(split_cmd)
  vim.cmd("Gedit " .. commit_ish)
end

-- Define git commit options with descriptions
local git_commit_options = {
  {
    description = "Commit                                                              1",
    action = function()
      -- split the current buffer horizontally spanning the bottom
      vim.cmd("botright split")
      -- open a fugitive commit buffer
      vim.cmd("Git commit")
      -- move **UP** to previous window (the one splitted horizontally previously)
      vim.cmd.wincmd("p")
      -- close that window (this will cause the cursor to move the original window that was splitted)
      vim.cmd("quit")
      -- move **DOWN** to the fugitive commit buffer
      vim.cmd.wincmd("j")
    end,
    count = 1,
  },
  {
    description = "Commit --amend                                                     11",
    action = function()
      utils.write_to_command_mode("Git commit --amend")
    end,
    count = 11,
  },
  {
    description = "Commit --amend --no-edit                                           12",
    action = function()
      utils.write_to_command_mode("Git commit --amend --no-edit")
    end,
    count = 12,
  },
  {
    description = "Commit --allow-empty                                               13",
    action = function()
      utils.write_to_command_mode("Git commit --allow-empty")
    end,
    count = 13,
  },
  {
    description = "Verify sign <cword>",
    action = function()
      utils.write_to_command_mode(
        "Git verify-commit "
          .. vim.fn.expand(highlight_text_under_cursor())
          .. " "
      )
    end,
  },
  {
    description = "Verify sign verbose <cword>",
    action = function()
      utils.write_to_command_mode(
        "Git verify-commit -v "
          .. vim.fn.expand(highlight_text_under_cursor())
          .. " "
      )
    end,
  },
  {
    description = "Search pattern: [ ./)(><]+",
    action = function()
      local search_text = "[ ./)(><|:'\"]\\+"
      vim.fn.setreg("/", search_text)
      vim.cmd("set hlsearch")
      pcall(vim.cmd.normal, { "n", bang = true })
    end,
  },
  {
    description = "Copy JIRA ticket from branch name",
    action = function()
      local git_head = vim.fn.FugitiveHead()
      local jira_ticket_pattern = git_head:match("^[A-Z]+%-[0-9]+")
      if jira_ticket_pattern then
        vim.fn.setreg("a", jira_ticket_pattern)
        vim.fn.setreg("+", jira_ticket_pattern)
        vim.notify("(Reg a & +) ticket -> " .. jira_ticket_pattern)
      else
        vim.notify(
          "No JIRA ticket pattern found in branch: " .. git_head
        )
      end
    end,
  },
  {
    description = "Copy current branch name to clipboard                               5",
    action = function()
      local git_head = vim.fn.FugitiveHead()
      vim.fn.setreg("+", git_head)
      vim.notify("(Reg +) current branch -> " .. git_head)
    end,
    count = 5,
  },
  {
    description = "Copy current branch name to register a                             55",
    action = function()
      local git_head = vim.fn.FugitiveHead()
      vim.fn.setreg("a", git_head)
      vim.notify("(Reg a) current branch -> " .. git_head)
    end,
    count = 55,
  },
  {
    description = "Show commit under cursor (split)",
    action = function()
      open_commit_under_cursor("split")
    end,
  },
  {
    description = "Show commit under cursor (vsplit)",
    action = function()
      open_commit_under_cursor("vsplit")
    end,
  },
  {
    description = "Show commit under cursor (tab)",
    action = function()
      open_commit_under_cursor("tab split")
    end,
  },
  {
    description = "Git prune origin",
    action = function()
      utils.write_to_command_mode("Git remote prune origin")
    end,
  },
  {
    description = "Git prune ",
    action = function()
      utils.write_to_command_mode("Git remote prune ")
    end,
  },
}

local git_commit_mappings_opts = {
  noremap = true,
  desc = "Git commit 0/fzf 1/cm 11/cm-amend 12/cm-amend-no-edit 13/cm-empty",
}

local function git_commit_mappings_fn()
  local keymap_count = vim.v.count

  -- utils.tab_split_if_multiple_windows()

  local fzf_lua = require("fzf-lua")

  -- Format options for display
  local items = {}
  for i, option in ipairs(git_commit_options) do
    if keymap_count == option.count then
      option.action()
      return
    end
    table.insert(items, string.format("%d. %s", i, option.description))
  end

  utils.set_fzf_lua_nvim_listen_address()

  fzf_lua.fzf_exec(items, {
    prompt = "Git Commit Options> ",
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then
          return
        end

        local selection = selected[1]
        -- Extract option index from selection
        local index = tonumber(selection:match("^(%d+)%."))
        if index and git_commit_options[index] then
          git_commit_options[index].action()
        end
      end,
    },
    fzf_opts = {
      ["--no-multi"] = "",
      ["--header"] = "Select a git commit option",
    },
  })
end

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

-- Define git rebase/reset/merge options with descriptions

local git_rebase_options = {
  {
    description = "Rebase                                                1",
    action = function()
      utils.write_to_command_mode("G rebase ")
    end,
    count = 1,
  },
  {
    description = "Rebase Main                                           11",
    action = function()
      utils.write_to_command_mode("G rebase main")
    end,
    count = 11,
  },
  {
    description = "Rebase Develop                                        12",
    action = function()
      utils.write_to_command_mode("G rebase develop")
    end,
    count = 12,
  },
  {
    description = "Rebase -i                                             2",
    action = function()
      utils.write_to_command_mode("G rebase -i ")
    end,
    count = 2,
  },
  {
    description = "Rebase -i root                                        21",
    action = function()
      utils.write_to_command_mode("G rebase -i --root")
    end,
    count = 21,
  },
  {
    description = "Rebase -i HEAD~                                       22",
    action = function()
      utils.write_to_command_mode("G rebase -i HEAD~")
    end,
    count = 22,
  },
  {
    description = "Rebase -i <cword> cursor                              23",
    action = function()
      utils.write_to_command_mode(
        "G rebase -i " .. vim.fn.expand(highlight_text_under_cursor())
      )
    end,
    count = 23,
  },
  {
    description = "Reset soft HEAD~                                      3",
    action = function()
      utils.write_to_command_mode("G reset --soft HEAD~")
    end,
    count = 3,
  },
  {
    description = "Reset soft <cword> cursor                             31",
    action = function()
      utils.write_to_command_mode(
        "G reset --soft "
          .. vim.fn.expand(highlight_text_under_cursor())
      )
    end,
    count = 31,
  },
  {
    description = "Reset soft                                           32",
    action = function()
      utils.write_to_command_mode("G reset --soft ")
    end,
    count = 32,
  },
  {
    description = "Reset hard HEAD~                                     4",
    action = function()
      utils.write_to_command_mode("G reset --hard HEAD~")
    end,
    count = 4,
  },
  {
    description = "Reset hard <cword> cursor                            41",
    action = function()
      utils.write_to_command_mode(
        "G reset --hard "
          .. vim.fn.expand(highlight_text_under_cursor())
      )
    end,
    count = 41,
  },
  {
    description = "Merge main                                           5",
    action = function()
      utils.write_to_command_mode("G merge main")
    end,
    count = 5,
  },
  {
    description = "Merge master                                         51",
    action = function()
      utils.write_to_command_mode("G merge master")
    end,
    count = 51,
  },
  {
    description = "Merge develop                                        52",
    action = function()
      utils.write_to_command_mode("G merge develop")
    end,
    count = 52,
  },
  {
    description = "Merge                                                53",
    action = function()
      utils.write_to_command_mode("G merge ")
    end,
    count = 53,
  },
  {
    description = "Git prune origin",
    action = function()
      utils.write_to_command_mode("Git remote prune origin")
    end,
  },
  {
    description = "Git prune ",
    action = function()
      utils.write_to_command_mode("Git remote prune ")
    end,
  },
}

local git_rebase_root_mappings_fn = function()
  local fzf_lua = require("fzf-lua")
  local keymap_count = vim.v.count

  local items = {}
  for i, option in ipairs(git_rebase_options) do
    if keymap_count == option.count then
      option.action()
      return
    end
    table.insert(items, string.format("%d. %s", i, option.description))
  end

  utils.set_fzf_lua_nvim_listen_address()

  fzf_lua.fzf_exec(items, {
    prompt = "Git Rebase/Reset/Merge Options> ",
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then
          return
        end

        local selection = selected[1]
        -- Extract option index from selection
        local index = tonumber(selection:match("^(%d+)%."))
        if index and git_rebase_options[index] then
          git_rebase_options[index].action()
        end
      end,
    },
    fzf_opts = {
      ["--no-multi"] = "",
      ["--header"] = "Select a git rebase/reset/merge option",
    },
  })
end

local git_rebase_mappings_opts = {
  noremap = true,
  desc = "Git rebase/reset/merge options (fzf)",
}

keymap(
  "n",
  "<Leader>r<Space>",
  git_rebase_root_mappings_fn,
  git_rebase_mappings_opts
)

keymap("n", "<Leader>rr", function()
  local count = vim.v.count

  if count == 0 then
    utils.write_to_command_mode("G rebase --continue")
    return
  end

  if count == 1 then
    utils.write_to_command_mode("G rebase --edit-todo")
    return
  end

  if count == 2 then
    utils.write_to_command_mode("G rebase --abort")
    return
  end
end, { noremap = true, desc = [[Git rebase 0/continue 1/edit 2/abort]] })
-- /END Rebase keymaps

-- Git mappings
local git_log_options = {
  {
    description = "Git refresh (status)              1",
    action = function()
      vim.cmd("Git")
      print("Git refreshed!")
    end,
    count = 1,
  },
  {
    description = "Log oneline                       11",
    action = function()
      vim.cmd("Git log --oneline")
    end,
    count = 11,
  },
  {
    description = "Log full                          12",
    action = function()
      vim.cmd("Git! log")
    end,
    count = 12,
  },
  {
    description = "Log graphical (lgg)               13",
    action = function()
      vim.cmd("Git! lgg")
    end,
    count = 13,
  },
  {
    description = "Log oneline current file          2",
    action = function()
      vim.cmd("Git log --oneline -- %")
    end,
    count = 2,
  },
  {
    description = "Log full current file             21",
    action = function()
      vim.cmd("Git log -- %")
    end,
    count = 21,
  },
  {
    description = "File history with diff split      123/223",
    action = function()
      vim.cmd("only")
      vim.cmd("0GcLog!")
      vim.cmd("vsplit")
      vim.cmd("diffthis")
      vim.cmd("wincmd h")
      vim.cmd("normal ]q") -- move to next item in quickfix window
      vim.cmd("diffthis") -- show diff
    end,
    count = 23,
  },
  {
    description = "File history quickfix (GcLog)     23",
    action = function()
      vim.cmd("0GcLog!")
    end,
    count = 123,
    count_match_fn = function(count)
      local str_count = "" .. count
      return (str_count:match("^%d23") or str_count:match("23%d$"))
    end,
  },
  {
    description = "Write log oneline but provide count           3",
    action = function()
      utils.write_to_command_mode("Git log --oneline -")
    end,
    count = 3,
  },
}

keymap("n", "<leader>gg", function()
  local fzf_lua = require("fzf-lua")
  local keymap_count = vim.v.count

  local items = {}
  for i, option in ipairs(git_log_options) do
    -- Check if count matches any action
    if
      (keymap_count == option.count)
      or (option.count_match_fn and option.count_match_fn(keymap_count))
    then
      option.action()
      return
    end

    -- If no count match, show FZF menu
    table.insert(items, string.format("%d. %s", i, option.description))
  end

  utils.set_fzf_lua_nvim_listen_address()

  fzf_lua.fzf_exec(items, {
    prompt = "Git Log Options> ",
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then
          return
        end

        local selection = selected[1]
        -- Extract option index from selection
        local index = tonumber(selection:match("^(%d+)%."))
        if index and git_log_options[index] then
          git_log_options[index].action()
        end
      end,
    },
    fzf_opts = {
      ["--no-multi"] = "",
      ["--header"] = "Select a git log option",
    },
  })
end, {
  noremap = true,
  desc = "Git commit 1/all 2/file% 3/all-",
})

-- git blame
keymap({ "n", "x" }, "<leader>gb", function()
  local count = vim.v.count

  if count == 0 then
    vim.cmd("Git blame")
    return
  end

  utils.write_to_command_mode("GBrowse")
end, { desc = "G blame/GBrowse" })

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
      desc = "Git commit options (fzf)",
    })

    keymap("n", "r<space>", git_rebase_root_mappings_fn, {
      buffer = true,
      noremap = true,
      desc = git_rebase_mappings_opts.desc,
    })
  end,
})

vim.g.fugitive_summary_format = "%d %s"
