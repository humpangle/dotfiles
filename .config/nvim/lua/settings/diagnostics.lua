local utils = require("utils")
local map_key = utils.map_key

local function format_diagnostic(diagnostic)
  local bufname =
    vim.fn.fnamemodify(vim.api.nvim_buf_get_name(diagnostic.bufnr), ":~:.")

  local line = diagnostic.lnum + 1 -- Convert to 1-based
  local end_line = diagnostic.end_lnum and (diagnostic.end_lnum + 1) or line
  local col = diagnostic.col + 1
  local end_col = diagnostic.end_col and (diagnostic.end_col + 1) or col
  local severity = vim.diagnostic.severity[diagnostic.severity]

  local message = diagnostic.message:gsub("\n", " <>")

  -- Format line range
  local line_str = line == end_line and tostring(line)
    or string.format("%d-%d", line, end_line)

  return string.format(
    "%s:%s col %d:%d [%s] %s",
    bufname,
    line_str,
    col,
    end_col,
    severity,
    message
  )
end

-- Get formatted diagnostics from specified buffer(s)
-- @param bufnr number|nil Buffer number (0 for current, nil for all)
-- @return table Array of formatted diagnostic messages
local function get_formatted_diagnostics(bufnr)
  local diagnostics = vim.diagnostic.get(bufnr)
  local messages = {}

  for _, diagnostic in ipairs(diagnostics) do
    table.insert(messages, format_diagnostic(diagnostic))
  end

  return messages
end

-- Copy diagnostics to a register
-- @param bufnr number|nil Buffer number (0 for current, nil for all)
-- @param register string Register to copy to ('a', '+', etc.)
local function copy_diagnostics_to_register(bufnr, register)
  local messages = get_formatted_diagnostics(bufnr)
  local all_messages = table.concat(messages, "\n\n")
  vim.fn.setreg(register, all_messages)
  vim.fn.setreg('"', all_messages)

  local scope = bufnr == 0 and "current buffer" or "all buffers"
  vim.notify(
    string.format(
      "%d diagnostics from %s to %s",
      #messages,
      scope,
      "register '" .. register .. "'"
    )
  )
end

local diagnostic_modes = {
  {
    config = {
      virtual_text = true,
      virtual_lines = false,
    },
    message = "Diagnostic virtual LINES enabled",
  },
  {
    config = {
      virtual_text = true,
      virtual_lines = {
        current_line = true,
      },
    },
    message = "Diagnostic virtual LINES disabled",
  },
  -- We may add more modes here if needed, e.g.:
  -- {
  --   config = {
  --     virtual_text = false,
  --     virtual_lines = false,
  --   },
  --   message = "Diagnostics OFF",
  -- },
}

local current_mode_index = 1
vim.diagnostic.config(diagnostic_modes[current_mode_index].config)

local fzf_lua_diagnostic_options = {
  {
    description = "Toggle Virtual Lines/Text                                                                        1",
    action = function()
      -- Cycle to the next mode
      local next_mode_index = (current_mode_index % #diagnostic_modes) + 1
      current_mode_index = next_mode_index

      local new_mode = diagnostic_modes[current_mode_index]
      vim.diagnostic.config(new_mode.config)
      vim.notify(new_mode.message)
    end,
    count = 1,
  },
  {
    description = "Open Line Popup (focusable)                                                                     11",
    action = function()
      vim.diagnostic.open_float({ focusable = true })
      vim.diagnostic.open_float({ focusable = true }) -- second invocation is to focus the popup
    end,
    count = 11,
  },
  {
    description = "Open Buffer Float (focusable)                                                                    5",
    action = function()
      vim.diagnostic.open_float({ focusable = true, scope = "buffer" })
      vim.diagnostic.open_float({ focusable = true, scope = "buffer" })
    end,
    count = 5,
  },
  {
    description = "Set Location List                                                                               51",
    action = function()
      vim.diagnostic.setloclist()
    end,
    count = 51,
  },
  {
    description = "Current Copy Current Buffer Diagnostics to Clipboard register +                                 52",
    action = function()
      copy_diagnostics_to_register(0, "+")
    end,
    count = 52,
  },
  {
    description = "Current Copy Current Buffer Diagnostics to Register 'a'                                        522",
    action = function()
      copy_diagnostics_to_register(0, "a")
    end,
    count = 522,
  },
  {
    description = "Copy All Buffers Diagnostics to Clipboard register +                                            53",
    action = function()
      copy_diagnostics_to_register(nil, "+")
    end,
    count = 53,
  },
  {
    description = "All Copy All Buffers Diagnostics to Register 'a'                                               533",
    action = function()
      copy_diagnostics_to_register(nil, "a")
    end,
    count = 533,
  },
  {
    description = "Debug: Print Current Config                                                                     99",
    action = function()
      local config_opts_as_str =
        vim.inspect(diagnostic_modes[current_mode_index].config)
      print(config_opts_as_str)
    end,
    count = 99,
  },
}

map_key("n", "<leader>lsd", function()
  local keymap_count = vim.v.count

  for _, option in ipairs(fzf_lua_diagnostic_options) do
    if keymap_count == option.count then
      option.action()
      return
    end
  end

  utils.create_fzf_key_maps(fzf_lua_diagnostic_options, {
    prompt = "LSP Diagnostics",
    header = "Select a LSP diagnostic option",
  })
end, {
  noremap = true,
  desc = "diagnostic 0/ 1/toggleVirtuals 11/linePopUp 5/listLoc 6/copyCurrentA 61/copyCurrentClip 50/bufFloat 52/copyAllA 53/copyAllClip 99/debug",
})
