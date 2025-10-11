local utils_status_ok, utils = pcall(require, "utils")
if not utils_status_ok then
  return
end

local fugitive_utils = require("plugins.fugitive.utils")
local fzf_lua_shared_options =
  require("plugins.fugitive.fzf-lua-shared-options")
local git_stash_shared_options =
  require("plugins.fugitive.git-stash-shared-options")

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

-- Git commit mappings

local tab_split = function()
  vim.cmd("tab split")
end

local get_git_current_branch = function()
  local git_tree_ish_head_list = vim.fn.systemlist(
    "( cd " .. vim.fn.getcwd(0) .. " &&  git branch --show-current)"
  )

  if #git_tree_ish_head_list == 1 then
    return git_tree_ish_head_list[1]
  elseif #git_tree_ish_head_list == 2 then
    return git_tree_ish_head_list[2]
  end

  return "ERROR"
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
      local git_head = get_git_current_branch()
      vim.fn.setreg("+", git_head)
      vim.notify("(Reg +) current branch -> " .. git_head)
    end,
    count = 5,
  },
  {
    description = "Copy current branch name to register a                             55",
    action = function()
      local git_head = get_git_current_branch()
      vim.fn.setreg("a", git_head)
      vim.notify("(Reg a) current branch -> " .. git_head)
    end,
    count = 55,
  },
  {
    description = "Show commit under cursor (split)",
    action = function()
      fugitive_utils.open_commit_under_cursor("split")
    end,
  },
  {
    description = "Show commit under cursor (vsplit)",
    action = function()
      fugitive_utils.open_commit_under_cursor("vsplit")
    end,
  },
  {
    description = "Show commit under cursor (tab)",
    action = function()
      tab_split()
      fugitive_utils.open_commit_under_cursor("tab split")
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
  fzf_lua_shared_options.submodule_update_force_recursive(),
  {
    description = "Git get commit",
    action = function()
      utils.write_to_command_mode("Git rev-parse ")
    end,
  },
  {
    description = "Git copy/get commit master register plus +",
    action = function()
      local git_master_head = fugitive_utils.get_git_commit("master")
      vim.fn.setreg("+", git_master_head)
      vim.notify("(Reg +) master branch -> " .. git_master_head)
    end,
  },
  {
    description = "Git get commit cursor <cWORD>",
    action = function()
      utils.write_to_command_mode(
        "Git rev-parse " .. vim.fn.expand("<cWORD>")
      )
    end,
  },
  fzf_lua_shared_options.check_out_tree_ish_under_cursor(),
  fzf_lua_shared_options.git_add_all(),
  fzf_lua_shared_options.copy_git_root_to_system_clipboard(),
  fzf_lua_shared_options.copy_main_head_commit_to_register_plus(),
  fzf_lua_shared_options.check_out_some_head_commit("main"),
  fzf_lua_shared_options.check_out_some_head_commit("develop"),
  fzf_lua_shared_options.submodule_deinit_all(),
  fzf_lua_shared_options.git_pull(),
  fzf_lua_shared_options.merge_main(),
  git_stash_shared_options.git_stash_list_plain(),
  git_stash_shared_options.git_stash_list_paginate(),
  git_stash_shared_options.git_stash_push_include_untracked(),
  git_stash_shared_options.git_stash_push_all(),
  git_stash_shared_options.git_stash_push_current_file(),
  git_stash_shared_options.git_stash_pop,
  git_stash_shared_options.git_stash_pop_index_zero,
  git_stash_shared_options.git_stash_pop_zero,
  git_stash_shared_options.git_stash_pop_index,
  git_stash_shared_options.git_stash_pop,
  git_stash_shared_options.git_stash_apply_index_zero,
  git_stash_shared_options.git_stash_apply_zero,
  git_stash_shared_options.git_stash_apply_index,
  git_stash_shared_options.git_stash_apply,
  git_stash_shared_options.git_stash_drop_index_zero,
  git_stash_shared_options.git_stash_drop_zero,
  git_stash_shared_options.git_stash_drop_index,
  git_stash_shared_options.git_stash_drop,
}

for _, value in pairs(fzf_lua_shared_options.verify_commit_sign()) do
  table.insert(git_commit_options, value)
end

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
        "G rebase -i " .. fugitive_utils.highlight_text_under_cursor()
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
          .. fugitive_utils.highlight_text_under_cursor()
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
          .. fugitive_utils.highlight_text_under_cursor()
      )
    end,
    count = 41,
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
  fzf_lua_shared_options.submodule_update_force_recursive(),
  {
    description = "Rebase master                                         ",
    action = function()
      utils.write_to_command_mode("G rebase master")
    end,
  },
  {
    description = "Merge abort",
    action = function()
      utils.write_to_command_mode("G merge --abort")
    end,
  },
  fzf_lua_shared_options.check_out_tree_ish_under_cursor(),
  fzf_lua_shared_options.git_add_all(),
  fzf_lua_shared_options.copy_git_root_to_system_clipboard(),
  fzf_lua_shared_options.copy_main_head_commit_to_register_plus(),
  fzf_lua_shared_options.check_out_some_head_commit("main"),
  fzf_lua_shared_options.check_out_some_head_commit("develop"),
  fzf_lua_shared_options.submodule_deinit_all(),
  fzf_lua_shared_options.git_pull(),
  fzf_lua_shared_options.merge_main(),
  git_stash_shared_options.git_stash_list_plain(),
  git_stash_shared_options.git_stash_list_paginate(),
  git_stash_shared_options.git_stash_push_include_untracked(),
  git_stash_shared_options.git_stash_push_all(),
  git_stash_shared_options.git_stash_push_current_file(),
  git_stash_shared_options.git_stash_pop_index_zero,
  git_stash_shared_options.git_stash_pop_zero,
  git_stash_shared_options.git_stash_pop_index,
  git_stash_shared_options.git_stash_pop,
  git_stash_shared_options.git_stash_apply_index_zero,
  git_stash_shared_options.git_stash_apply_zero,
  git_stash_shared_options.git_stash_apply_index,
  git_stash_shared_options.git_stash_apply,
  git_stash_shared_options.git_stash_drop_index_zero,
  git_stash_shared_options.git_stash_drop_zero,
  git_stash_shared_options.git_stash_drop_index,
  git_stash_shared_options.git_stash_drop,
}

for _, value in pairs(fzf_lua_shared_options.verify_commit_sign()) do
  table.insert(git_rebase_options, value)
end

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
    description = "Git refresh (status) THIS CWD                            1",
    action = fugitive_utils.git_refresh_cwd,
    count = 1,
  },
  {
    description = "Log oneline THIS CWD                                    11",
    action = function()
      utils.handle_cant_re_enter_normal_mode_from_terminal_mode(function()
        vim.cmd("Git log --oneline")
      end, {
        force = true,
        wipe = true,
      })
    end,
    count = 11,
  },
  {
    description = "Log full THIS CWD                                       12",
    action = function()
      utils.handle_cant_re_enter_normal_mode_from_terminal_mode(function()
        vim.cmd("Git! log")
      end, {
        force = true,
        wipe = true,
      })
    end,
    count = 12,
  },
  {
    description = "Log graphical (lgg) THIS CWD                            13",
    action = function()
      utils.handle_cant_re_enter_normal_mode_from_terminal_mode(function()
        vim.cmd("Git! lgg")
      end, {
        force = true,
        wipe = true,
      })
    end,
    count = 13,
  },
  {
    description = "Log oneline current file                                 2",
    action = function()
      vim.cmd("Git log --oneline -- %")
    end,
    count = 2,
  },
  {
    description = "Log full current file                                   21",
    action = function()
      vim.cmd("Git log -- %")
    end,
    count = 21,
  },
  {
    description = "File history with diff split                       123/223",
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
    description = "File history quickfix (GcLog)                           23",
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
    description = "Write log oneline but provide count                      3",
    action = function()
      utils.write_to_command_mode("Git log --oneline -")
    end,
    count = 3,
  },
  {
    description = "Git refresh (status) OTHER CWD",
    action = function()
      vim.cmd("Git")
      print("Git refreshed!")
    end,
  },
  {
    description = "Log oneline OTHER CWD",
    action = function()
      vim.cmd("Git log --oneline")
    end,
  },
  fzf_lua_shared_options.git_pull(),
  fzf_lua_shared_options.merge_main(),
  git_stash_shared_options.git_stash_list_plain(),
  git_stash_shared_options.git_stash_list_paginate(),
  git_stash_shared_options.git_stash_push_include_untracked(),
  git_stash_shared_options.git_stash_push_all(),
  git_stash_shared_options.git_stash_push_current_file(),
  fzf_lua_shared_options.check_out_some_head_commit("main"),
  fzf_lua_shared_options.check_out_some_head_commit("develop"),
  git_stash_shared_options.git_stash_pop_index_zero,
  git_stash_shared_options.git_stash_pop_zero,
  git_stash_shared_options.git_stash_pop_index,
  git_stash_shared_options.git_stash_pop,
  git_stash_shared_options.git_stash_apply_index_zero,
  git_stash_shared_options.git_stash_apply_zero,
  git_stash_shared_options.git_stash_apply_index,
  git_stash_shared_options.git_stash_apply,
  git_stash_shared_options.git_stash_drop_index_zero,
  git_stash_shared_options.git_stash_drop_zero,
  git_stash_shared_options.git_stash_drop_index,
  git_stash_shared_options.git_stash_drop,
}

keymap("n", "<leader>gg", function()
  utils.create_fzf_key_maps(git_log_options, {
    prompt = "Git Log Options>  ",
    header = "Select a git log option",
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
