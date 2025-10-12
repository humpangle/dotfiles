local utils = require("utils")
local fugitive_utils = require("plugins.fugitive.utils")

local m = {
  {
    description = "Rebase                                                                                           1",
    action = function()
      utils.write_to_command_mode("G rebase ")
    end,
    count = 1,
  },
  {
    description = "Rebase Main                                                                                     11",
    action = function()
      utils.write_to_command_mode("G rebase main")
    end,
    count = 11,
  },
  {
    description = "Rebase Develop                                                                                  12",
    action = function()
      utils.write_to_command_mode("G rebase develop")
    end,
    count = 12,
  },
  {
    description = "Rebase -i                                                                                        2",
    action = function()
      utils.write_to_command_mode("G rebase -i ")
    end,
    count = 2,
  },
  {
    description = "Rebase -i root                                                                                  21",
    action = function()
      utils.write_to_command_mode("G rebase -i --root")
    end,
    count = 21,
  },
  {
    description = "Rebase -i HEAD~                                                                                 22",
    action = function()
      utils.write_to_command_mode("G rebase -i HEAD~")
    end,
    count = 22,
  },
  {
    description = "Rebase -i <cword> cursor                                                                        23",
    action = function()
      utils.write_to_command_mode(
        "G rebase -i " .. fugitive_utils.highlight_text_under_cursor()
      )
    end,
    count = 23,
  },
  {
    description = "Reset soft HEAD~                                                                                 3",
    action = function()
      utils.write_to_command_mode("G reset --soft HEAD~")
    end,
    count = 3,
  },
  {
    description = "Reset soft <cword> cursor                                                                       31",
    action = function()
      utils.write_to_command_mode(
        "G reset --soft "
          .. fugitive_utils.highlight_text_under_cursor()
      )
    end,
    count = 31,
  },
  {
    description = "Reset soft                                                                                      32",
    action = function()
      utils.write_to_command_mode("G reset --soft ")
    end,
    count = 32,
  },
  {
    description = "Reset hard HEAD~                                                                                 4",
    action = function()
      utils.write_to_command_mode("G reset --hard HEAD~")
    end,
    count = 4,
  },
  {
    description = "Reset hard <cword> cursor                                                                       41",
    action = function()
      utils.write_to_command_mode(
        "G reset --hard "
          .. fugitive_utils.highlight_text_under_cursor()
      )
    end,
    count = 41,
  },
  {
    description = "Merge master                                                                                    51",
    action = function()
      utils.write_to_command_mode("G merge master")
    end,
    count = 51,
  },
  {
    description = "Merge develop                                                                                   52",
    action = function()
      utils.write_to_command_mode("G merge develop")
    end,
    count = 52,
  },
  {
    description = "Merge                                                                                           53",
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
}

utils.add_options(
  m,
  require("plugins.fugitive.shared-miscellaneous-options"),
  require("plugins.fugitive.shared-stash-options"),
  require("plugins.fugitive.pull-options")
)

return m
