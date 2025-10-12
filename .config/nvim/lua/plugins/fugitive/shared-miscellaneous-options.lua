local utils = require("utils")
local fugitive_utils = require("plugins.fugitive.utils")

local m = {}

m.add = {
  description = "Git add . current working directory git root",
  action = function()
    local git_root = utils.get_git_root()
    local cmd = {
      "(",
      "cd " .. git_root,
      "&&",
      "git add .",
      ")",
    }
    local cmd_str = table.concat(cmd, " ")
    local result = vim.fn.systemlist(cmd_str)

    if #result > 0 then
      vim.print(table.concat(result, "\n"))
    else
      vim.print("Git added " .. git_root)
      fugitive_utils.git_refresh_cwd()
    end
  end,
}

m.init = {
  description = "Git init . current working directory",
  action = function()
    local cmd = {
      "(",
      "cd " .. vim.fn.getcwd(),
      "&&",
      "git init",
      ")",
    }
    local cmd_str = table.concat(cmd, " ")
    local result = vim.fn.systemlist(cmd_str)
    vim.print(table.concat(result, "\n"))

    fugitive_utils.git_refresh_cwd()
  end,
}

m.check_out_tree_ish_under_cursor = {
  description = "Git checkout under cursor <cword>",
  action = function()
    utils.write_to_command_mode(
      "G checkout " .. fugitive_utils.highlight_text_under_cursor()
    )
  end,
}

m.submodule_update_force_recursive = {
  description = "Git submodule update force recursive",
  action = function()
    utils.write_to_command_mode("Git submodule update --force --recursive")
  end,
}

m.copy_git_root_to_system_clipboard = {
  description = "Git Copy git root to system clipboard +",
  action = function()
    local git_root = utils.get_git_root() or "ERROR"

    vim.fn.setreg("", git_root)
    vim.fn.setreg("+", git_root)

    vim.notify("Git root copied to +: " .. git_root)
  end,
}

m.verify_commit_sign = {
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

m.copy_main_head_commit_to_register_plus = {
  description = "Git copy/get commit main HEAD commit to system clipboard - register plus +",
  action = function()
    local git_main_head = fugitive_utils.get_git_commit("main")
    vim.fn.setreg("+", git_main_head)
    vim.notify("(Reg +) main branch -> " .. git_main_head)
  end,
}

m.submodule_deinit_all = {
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

m.git_pull = {
  description = "Git Pull Fetch",
  action = function()
    fugitive_utils.git_refresh_cwd()
    vim.cmd("Git fetch")

    utils.write_to_command_mode("Git pull origin " .. vim.fn.FugitiveHead())
  end,
  count = 6,
}

m.merge_main = {
  description = "Merge main",
  action = function()
    utils.write_to_command_mode("G merge main")
  end,
}

for _, branch_name in ipairs({ "main", "master", "develop" }) do
  table.insert(m, {
    description = "Check out commit " .. branch_name .. " HEAD commit",
    action = function()
      local git_branch_name_head =
        fugitive_utils.get_git_commit(branch_name)
      vim.fn.setreg("+", git_branch_name_head)

      local checkout_result = vim.fn.systemlist(
        "( cd "
          .. vim.fn.getcwd(0)
          .. " &&  git checkout "
          .. git_branch_name_head
          .. " )"
      )

      if checkout_result[#checkout_result] == "Aborting" then
        vim.print(
          "Could not checkout "
            .. branch_name
            .. " HEAD commit: "
            .. git_branch_name_head
        )
        return
      end

      vim.print(
        "Checked out branch from "
          .. branch_name
          .. " HEAD -> "
          .. git_branch_name_head
      )

      vim.defer_fn(fugitive_utils.git_refresh_cwd, 10)
    end,
  })
end

-- TODO: replace “, ” and ’
return m
