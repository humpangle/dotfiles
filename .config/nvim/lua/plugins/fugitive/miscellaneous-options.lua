local fugitive_utils = require("plugins.fugitive.utils")

local m = {}

m.add = {
  description = "Git add . current working directory",
  action = function()
    local cmd = {
      "(",
      "cd " .. vim.fn.getcwd(),
      "&&",
      "git add .",
      ")",
    }
    local cmd_str = table.concat(cmd, " ")
    local result = vim.fn.systemlist(cmd_str)

    if #result > 0 then
      vim.print(table.concat(result, "\n"))
    else
      vim.print("Git added .")
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

return m
