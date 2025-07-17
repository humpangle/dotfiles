local M = {}

-- Define search patterns with descriptions
M.patterns = {
  {
    description = "Test session start",
    pattern = "========= test session starts ========",
    navigation = "N", -- Jump to first occurrence
  },
  {
    description = ".py with F or E",
    pattern = "\\.py[^:]*[FE]",
    navigation = "N",
  },
  {
    description = "FAILURES/ERRORS",
    -- pytest|Vitest
    pattern = "=========== \\(FAILURES\\|ERRORS\\) ======================\\|⎯⎯ Failed Tests \\d\\+ ⎯⎯",
    navigation = "N",
  },
  {
    description = "Test name (_ test_ _)",
    pattern = "_ .*test_.\\+ _",
    navigation = "N",
  },
  {
    description = "Captured",
    pattern = "------- Captured ",
    navigation = "N",
  },
  {
    description = "ERROR markers",
    pattern = "ERROR\\s\\+",
    navigation = "n", -- Jump to next occurrence (lowercase)
  },
  {
    description = "Short test summary info",
    pattern = "= short test summary info =",
    navigation = "N",
  },
  {
    description = "Datetime Timestamps (YYYY-MM-DD HH:MM:SS)",
    -- This will now match:
    -- - 2024-01-15 (just date)
    -- - 2024-01-15 14 (date and hour)
    -- - 2024-01-15 14:30 (date, hour:minute)
    -- - 2024-01-15 14:30:45 (date, hour:minute:second)
    -- - 2024-01-15 14:30:45.123 (with fractional seconds)
    pattern = "\\d\\{4\\}-\\d\\{2\\}-\\d\\{2\\}\\([^\\d]\\d\\{2\\}\\(:\\d\\{2\\}\\(:\\d\\{2\\}\\(\\.\\d\\+\\)*\\)\\?\\)\\?\\)\\?",
    navigation = "N",
  },
  {
    description = "1 of 2 [1/2]",
    pattern = "[\\d\\+\\/\\d\\+\\]",
    navigation = "N",
  },
  {
    description = "JSON comment",
    pattern = '//\\s*".*',
    navigation = "N",
  },
  {
    description = "One Star",
    pattern = "\\*",
    navigation = "N",
  },
  {
    description = "Two Stars",
    pattern = "\\*\\*",
    navigation = "N",
  },
}

local function apply_search_pattern(pattern_data)
  -- Reload buffer to ensure clean state
  vim.cmd({ cmd = "edit", bang = true })

  -- Set the search register
  vim.fn.setreg("/", pattern_data.pattern)

  -- Enable search highlighting
  vim.cmd("set hlsearch")

  -- Navigate to first/next match
  pcall(vim.cmd.normal, { pattern_data.navigation, bang = true })
end

local function setup()
  local utils = require("utils")

  utils.map_key("n", "<leader>se", function()
    local fzf_lua = require("fzf-lua")

    -- Format patterns for display
    local items = {}
    for i, pattern in ipairs(M.patterns) do
      table.insert(
        items,
        string.format(
          "%d. %s :: %s",
          i,
          pattern.description,
          pattern.pattern
        )
      )
    end

    -- fzf picker
    fzf_lua.fzf_exec(items, {
      prompt = "Search Patterns> ",
      actions = {
        ["default"] = function(selected)
          if not selected or #selected == 0 then
            return
          end

          local selection = selected[1]
          -- Extract pattern index from selection
          local index = tonumber(selection:match("^(%d+)%."))
          if index and M.patterns[index] then
            apply_search_pattern(M.patterns[index])
          end
        end,
      },
      fzf_opts = {
        ["--no-multi"] = "",
        ["--header"] = "Select a search pattern to highlight",
      },
    })
  end, {
    desc = "Select and highlight search patterns",
  })
end

setup()

return M
