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

map_key("n", "<leader>lsd", function()
  local count = vim.v.count

  if count == 0 then
    -- Cycle to the next mode
    local next_mode_index = (current_mode_index % #diagnostic_modes) + 1
    current_mode_index = next_mode_index

    local new_mode = diagnostic_modes[current_mode_index]
    vim.diagnostic.config(new_mode.config)
    vim.notify(new_mode.message)
    return
  end

  if count == 1 then
    vim.diagnostic.open_float({ focusable = true })
    vim.diagnostic.open_float({ focusable = true }) -- second invocation is to focus the popup
    return
  end

  if count == 5 then
    vim.diagnostic.setloclist()
    return
  end

  if count == 55 then
    vim.diagnostic.open_float({ focusable = true, scope = "buffer" })
    vim.diagnostic.open_float({ focusable = true, scope = "buffer" })
    return
  end

  if count == 99 then
    local config_opts_as_str =
      vim.inspect(diagnostic_modes[current_mode_index].config)
    print(config_opts_as_str)
    return
  end
end, {
  desc = "diagnostic 0/toggleVirtuals 1/linePopUp 5/listLoc 55/listFloat  99/debug",
})
