local utils = require("utils")
local fugitive_utils = require("plugins.fugitive.utils")
local session_utils = require("session-utils")

local m = {
  {
    description = "LSP Restart Start/Stop                                                                           1",
    action = function()
      vim.cmd("LspStop")
      vim.defer_fn(function()
        vim.cmd("LspStart")
        vim.print("LSP restarted/attached")
      end, 10)
    end,
    count = 1,
  },
  {
    description = "LSP Stop                                                                                         2",
    action = function()
      vim.cmd("LspStop")
      vim.print("LspStopped 1<leader>ls0 to re-start/attach")
    end,
    count = 2,
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

local function my_status_add_git_info(lines)
  local git_branch = vim.fn.systemlist(
    "(cd " .. vim.fn.getcwd() .. " && git branch --show-current)"
  )[1] or "Not in git repo"

  table.insert(lines, "==Git Branch==")
  table.insert(lines, git_branch)
  table.insert(lines, fugitive_utils.get_git_commit("HEAD"))
end

local function my_status_add_session_info(lines)
  table.insert(lines, "")
  table.insert(lines, "==Session File==")
  table.insert(lines, session_utils.get_session_path_relative())
  table.insert(lines, "")
  table.insert(lines, "==Working Directory==")
  table.insert(lines, vim.fn.getcwd())
end

local function my_status_add_all_session_files(lines)
  local session_files = session_utils.get_all_session_files()
  if session_files then
    table.insert(lines, "")
    table.insert(lines, "")
    table.insert(lines, "==All Session Files==")
    for _, session_file in ipairs(session_files) do
      table.insert(lines, session_file)
    end
  end
end

local function my_status_add_llm_info(lines)
  table.insert(lines, "")
  table.insert(lines, "==LLM INFO==")
  table.insert(
    lines,
    vim.fn.systemlist("_dot rt")[1] .. "/llm-templates/claude/.claude"
  )
end

local function my_status_add_runtimepath(lines)
  table.insert(lines, "")
  table.insert(lines, "==Runtime Path==")

  for path in string.gmatch(vim.o.runtimepath, "[^,]+") do
    table.insert(lines, path)
  end
end

table.insert(m, {
  description = "My Neovim Status                                                                                          9",
  action = function()
    -- Create new buffer
    vim.cmd("tabnew")
    vim.cmd("setlocal buftype=nofile")
    vim.cmd("setlocal bufhidden=hide")
    vim.cmd("setlocal noswapfile")
    utils.write_to_out_file({
      additional_directory_path = "my-neovim-status",
      prefix = "my-neovim-status",
      ext = "log",
    })

    -- Write status information
    local lines = {
      "My Status",
      "==============================================================================================================",
      "",
    }

    my_status_add_git_info(lines)
    my_status_add_session_info(lines)
    my_status_add_all_session_files(lines)
    my_status_add_llm_info(lines)
    my_status_add_runtimepath(lines)

    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.cmd("w!")
  end,
  count = 9,
})

return m
