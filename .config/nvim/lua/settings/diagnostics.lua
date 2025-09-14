local utils = require("utils")
local map_key = utils.map_key

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
    description = "Set Location List                                                                                5",
    action = function()
      vim.diagnostic.setloclist()
    end,
    count = 5,
  },
  {
    description = "Open Buffer Float (focusable)                                                                   55",
    action = function()
      vim.diagnostic.open_float({ focusable = true, scope = "buffer" })
      vim.diagnostic.open_float({ focusable = true, scope = "buffer" })
    end,
    count = 55,
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
  desc = "diagnostic 0/ 1/toggleVirtuals 11/linePopUp 5/listLoc 55/listFloat 99/debug",
})
