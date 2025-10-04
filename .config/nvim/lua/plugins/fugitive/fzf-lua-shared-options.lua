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

function M.copy_main_head_commit_to_register_plus()
  return {
    description = "Git copy/get commit main HEAD commit to system clipboard - register plus +",
    action = function()
      local git_main_head = fugitive_utils.get_git_commit("main")
      vim.fn.setreg("+", git_main_head)
      vim.notify("(Reg +) main branch -> " .. git_main_head)
    end,
  }
end

function M.check_out_main_head_commit()
  return {
    description = "Check out commit main HEAD commit",
    action = function()
      local git_main_head = fugitive_utils.get_git_commit("main")
      vim.fn.setreg("+", git_main_head)

      local checkout_result = vim.fn.systemlist(
        "( cd "
          .. vim.fn.getcwd(0)
          .. " &&  git checkout "
          .. git_main_head
          .. " )"
      )

      if checkout_result[#checkout_result] == "Aborting" then
        vim.print(
          "Could not checkout main HEAD commit: " .. git_main_head
        )
        return
      end

      vim.print("Checked out branch from main HEAD -> " .. git_main_head)

      vim.defer_fn(fugitive_utils.git_refresh_cwd, 10)
    end,
  }
end

function M.submodule_deinit_all()
  return {
    description = "Submodule deinit reset all",
    action = function()
      local result_list = {}
      local reset_all_env_val =
        utils.get_os_env_or_nil("GIT_SUBMODULE_RESET_ALL")

      if reset_all_env_val then
        local cmd_from_env = (
          "( cd "
          .. vim.fn.getcwd(0)
          .. " &&  "
          .. reset_all_env_val
          .. " )"
        ):gsub("\n", " ")

        vim.print("Invoking CMD from env: " .. cmd_from_env)

        result_list = vim.fn.systemlist(cmd_from_env)
      else
        local cmd = "( cd "
          .. vim.fn.getcwd(0)
          .. " &&  git submodule deinit -f --all"
          .. " )"

        result_list = vim.fn.systemlist(cmd)
        vim.print("Invoking default CMD: " .. cmd)
      end

      local result_str = "ERROR"

      if #result_list > 0 then
        result_str = table.concat(result_list, "\n\n")
      end

      vim.print("Result git submodule deinit all: " .. result_str)
    end,
  }
end

function M.git_pull()
  return {
    description = "Git Pull Fetch",
    action = function()
      fugitive_utils.git_refresh_cwd()
      vim.cmd("Git fetch")

      utils.write_to_command_mode(
        "Git pull origin " .. vim.fn.FugitiveHead()
      )
    end,
    count = 6,
  }
end

function M.merge_main()
  return {
    description = "Merge main",
    action = function()
      utils.write_to_command_mode("G merge main")
    end,
  }
end

-- TODO: replace “, ” and ’

return M
