local utils = require("utils")
local fugitive_utils = require("plugins.fugitive.utils")

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

local m = {
  {
    description = "Commit                                                                                           1",
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
    description = "Commit --amend                                                                                  11",
    action = function()
      utils.write_to_command_mode("Git commit --amend")
    end,
    count = 11,
  },
  {
    description = "Commit --amend --no-edit                                                                        12",
    action = function()
      utils.write_to_command_mode("Git commit --amend --no-edit")
    end,
    count = 12,
  },
  {
    description = "Commit --allow-empty                                                                            13",
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
    description = "Copy current branch name to clipboard                                                            5",
    action = function()
      local git_head = get_git_current_branch()
      vim.fn.setreg("+", git_head)
      vim.notify("(Reg +) current branch -> " .. git_head)
    end,
    count = 5,
  },
  {
    description = "Copy current branch name to register a                                                          55",
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
}

utils.add_options(
  m,
  require("plugins.fugitive.shared-miscellaneous-options"),
  require("plugins.fugitive.pull-options"),
  require("plugins.fugitive.shared-stash-options"),
  require("plugins.fugitive.shared-rebase-options"),
  require("plugins.fzf-lua.fzf-lua-fzf-lua-options")
)

return m
