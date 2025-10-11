local utils = require("utils")
local fugitive_utils = require("plugins.fugitive.utils")
local obsession_utils = require("plugins.vim-obsession.obsession-utils")

local m = {
  {
    description = "LSP Stop                                                                                         2",
    action = function()
      vim.cmd("LspStop")
      vim.cmd.echo('"LspStopped 3<leader>ls0 to start"')
    end,
    count = 2,
  },
  {
    description = "LSP Start Attach                                                                                22",
    action = function()
      vim.cmd("LspStart")
      vim.cmd.echo('"LspStart"')
    end,
    count = 22,
  },
  {
    description = "LSP Info",
    action = function()
      vim.cmd("LspInfo")
    end,
  },
  {
    description = "LSP Log",
    action = function()
      vim.cmd("LspLog")
    end,
  },
  {
    description = "Treesitter Context Go To (level 1)                                                               4",
    action = function()
      -- TODO: implement dynamic level up
      -- 40 == 1, 41 == 1, 42 == 2
      local level_up = 1
      require("treesitter-context").go_to_context(level_up)
    end,
    count = 4,
  },
  {
    description = "Treesitter Context Toggle                                                                       44",
    action = function()
      vim.cmd("TSContext toggle")
      print("TSContext toggle")
    end,
    count = 44,
  },
  {
    description = "Twilight Toggle                                                                                 45",
    action = function()
      local twilight_view = require("twilight.view")
      if twilight_view.enabled then
        twilight_view.disable()
        vim.notify("Twilight disabled")
      else
        twilight_view.enable()
        vim.notify("Twilight enabled")
      end
    end,
    count = 45,
  },
}

table.insert(m, {
  description = "My Status                                                                                          9",
  action = function()
    local git_branch = vim.fn.systemlist(
      "(cd " .. vim.fn.getcwd() .. " && git branch --show-current)"
    )[1] or "Not in git repo"

    -- Create new buffer
    vim.cmd("tabnew")
    vim.cmd("setlocal buftype=nofile")
    vim.cmd("setlocal bufhidden=hide")
    vim.cmd("setlocal noswapfile")
    utils.write_to_out_file({ prefix = "my-neovim-sesion", ext = "log" })

    -- Write status information
    local lines = {
      "My Status",
      "==============================================================================================================",
      "",
      "==Git Branch==",
      git_branch,
      "",
      "==HEAD Commit==",
      fugitive_utils.get_git_commit("HEAD"),
      "",
      "==Session File==",
      obsession_utils.get_session_path_relative(),
      "",
      "==Working Directory==",
      vim.fn.getcwd(),
    }

    local session_files = obsession_utils.get_all_session_files()
    if session_files then
      table.insert(lines, "")
      table.insert(lines, "")
      table.insert(lines, "==All Session Files==")
      for _, session_file in ipairs(session_files) do
        table.insert(lines, session_file)
      end
    end
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  end,
  count = 9,
})

return m
