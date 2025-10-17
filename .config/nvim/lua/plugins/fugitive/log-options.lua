local utils = require("utils")
local fugitive_utils = require("plugins.fugitive.utils")

local log_options = {
  {
    description = "Git refresh (status) THIS CWD                                                                    1",
    action = fugitive_utils.git_refresh_cwd,
    count = 1,
  },
  {
    description = "Log oneline THIS CWD                                                                            11",
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
    description = "Git Log full THIS CWD                                                                           12",
    action = function()
      utils.handle_cant_re_enter_normal_mode_from_terminal_mode(function()
        vim.cmd("tab split")
        vim.cmd("Git! log")
        vim.defer_fn(function()
          vim.cmd("only")
        end, 5)
      end, {
        force = true,
        wipe = true,
      })
    end,
    count = 12,
  },
  {
    description = "Log graphical (lgg) THIS CWD                                                                    13",
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
    description = "Log oneline current file                                                                         2",
    action = function()
      vim.cmd("Git log --oneline -- %")
    end,
    count = 2,
  },
  {
    description = "Log full current file                                                                           21",
    action = function()
      vim.cmd("Git log -- %")
    end,
    count = 21,
  },
  {
    description = "File history with diff split                                                               123/223",
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
    description = "File history quickfix (GcLog)                                                                   23",
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
    description = "Write log oneline but provide count                                                              3",
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
}
utils.add_options(
  log_options,
  require("plugins.fugitive.shared-miscellaneous-options"),
  require("plugins.fugitive.shared-stash-options"),
  require("plugins.fugitive.pull-options"),
  require("plugins.fugitive.shared-rebase-options")
)

return log_options
