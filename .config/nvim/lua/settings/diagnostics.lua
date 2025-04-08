local utils = require("utils")
local map_key = utils.map_key

local config_opts = {
  virtual_text = true,
  virtual_lines = false,
}

local default_config = {
  virtual_text = true,
  -- virtual_lines = true,
  virtual_lines = {
    current_line = true,
  },
}

vim.diagnostic.config(config_opts)

map_key("n", "<leader>lsd", function()
  local count = vim.v.count

  if count == 0 then
    local msg = ""
    if config_opts.virtual_lines == false then
      config_opts.virtual_lines = default_config.virtual_lines
      config_opts.virtual_text = false
      msg = "Diagnostic virtual LINES enabled"
    elseif config_opts.virtual_text == false then
      config_opts.virtual_text = default_config.virtual_text
      config_opts.virtual_lines = false
      msg = "Diagnostic virtual TEXT enabled"
    end

    vim.diagnostic.config(config_opts)
    vim.notify(msg)
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
    local config_opts_as_str = vim.inspect(config_opts)
    print(config_opts_as_str)
    return
  end
end, {
  desc = "diagnostic 0/toggleVirtuals 1/linePopUp 5/listLoc 55/listFloat  99/debug",
})
