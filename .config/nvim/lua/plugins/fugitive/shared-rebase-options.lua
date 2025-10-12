local utils = require("utils")
local fugitive_utils = require("plugins.fugitive.utils")

local m = {
  {
    description = "Rebase",
    action = function()
      utils.write_to_command_mode("G rebase ")
    end,
  },
  {
    description = "Rebase -i",
    action = function()
      utils.write_to_command_mode("G rebase -i ")
    end,
  },
  {
    description = "Rebase -i root",
    action = function()
      utils.write_to_command_mode("G rebase -i --root")
    end,
  },
  {
    description = "Rebase -i HEAD~",
    action = function()
      utils.write_to_command_mode("G rebase -i HEAD~")
    end,
  },
  {
    description = "Rebase -i <cword> cursor",
    action = function()
      utils.write_to_command_mode(
        "G rebase -i " .. fugitive_utils.highlight_text_under_cursor()
      )
    end,
  },
  {
    description = "Reset soft HEAD~",
    action = function()
      utils.write_to_command_mode("G reset --soft HEAD~")
    end,
  },
  {
    description = "Reset soft <cword> cursor",
    action = function()
      utils.write_to_command_mode(
        "G reset --soft "
          .. fugitive_utils.highlight_text_under_cursor()
      )
    end,
  },
  {
    description = "Reset soft",
    action = function()
      utils.write_to_command_mode("G reset --soft ")
    end,
  },
  {
    description = "Reset hard HEAD~",
    action = function()
      utils.write_to_command_mode("G reset --hard HEAD~")
    end,
  },
  {
    description = "Reset hard <cword> cursor",
    action = function()
      utils.write_to_command_mode(
        "G reset --hard "
          .. fugitive_utils.highlight_text_under_cursor()
      )
    end,
  },
  {
    description = "Merge",
    action = function()
      utils.write_to_command_mode("G merge ")
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
    description = "Merge abort",
    action = function()
      utils.write_to_command_mode("G merge --abort")
    end,
  },
}

for _, branch_name in ipairs({ "main", "master", "develop" }) do
  table.insert(m, {
    description = "Merge " .. branch_name,
    action = function()
      utils.write_to_command_mode("G merge " .. branch_name)
    end,
  })

  table.insert(m, {
    description = "Rebase " .. branch_name,
    action = function()
      utils.write_to_command_mode("G rebase " .. branch_name)
    end,
  })
end

return m
