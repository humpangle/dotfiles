local M = {}
local utils = require("utils")
local fugitive_utils = require("plugins.fugitive.utils")

function M.check_out_tree_ish_under_cursor()
  return {
    description = "Git checkout under cursor <cword>",
    action = function()
      utils.write_to_command_mode(
        "G checkout " .. fugitive_utils.highlight_text_under_cursor()
      )
    end,
  }
end

function M.submodule_update_force_recursive()
  return {
    description = "Git submodule update force recursive",
    action = function()
      utils.write_to_command_mode(
        "Git submodule update --force --recursive"
      )
    end,
  }
end

function M.check_out_head_of_main_branch()
  return {
    description = "Git checkout main HEAD",
    action = function()
      local git_main_head = fugitive_utils.get_git_commit("main")
      vim.cmd("! git checkout " .. git_main_head)
      vim.notify("Main HEAD checked out: " .. git_main_head)
    end,
  }
end

function M.git_add_all()
  return {
    description = "Git Add all git root",
    action = function()
      local git_root = utils.get_git_root()

      if git_root then
        vim.cmd("! git add " .. git_root)
        vim.notify("Git add: " .. git_root)
        return
      end

      vim.notify("Git root not found!", vim.log.levels.ERROR)
    end,
  }
end

function M.copy_git_root_to_system_clipboard()
  return {
    description = "Git Copy git root to system clipboard +",
    action = function()
      local git_root = utils.get_git_root() or "ERROR"

      vim.fn.setreg("", git_root)
      vim.fn.setreg("+", git_root)

      vim.notify("Git root copied to +: " .. git_root)
    end,
  }
end

function M.verify_commit_sign()
  return {
    {
      description = "Verify sign <cword>",
      action = function()
        utils.write_to_command_mode(
          "Git verify-commit "
            .. fugitive_utils.highlight_text_under_cursor()
            .. " "
        )
      end,
    },
    {
      description = "Verify sign verbose <cword>",
      action = function()
        utils.write_to_command_mode(
          "Git verify-commit -v "
            .. fugitive_utils.highlight_text_under_cursor()
            .. " "
        )
      end,
    },
  }
end

return M
