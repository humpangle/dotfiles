local utils = require("utils")
local m = {}

m.do_format = function()
  -- Reset verbosity in case we already increased verbosity in an earlier call.
  vim.g.neoformat_verbose = 0

  local count = vim.v.count
  local mode = vim.fn.mode()

  if count == 1 then
    if mode == "n" then
      vim.cmd.normal({ "vip" })
    end

    utils.write_to_command_mode("'<,'>Neoformat! ")
    return
  end

  if count ~= 0 then
    vim.g.neoformat_verbose = 1
  end

  vim.cmd("Neoformat")
  -- Neoformat converts spaces to tabs - we retab to force spaces
  vim.cmd({ cmd = "retab", bang = true })
  -- Neoformat marks the buffer as dirty - save the buffer
  -- vim.cmd("silent w")
end

return m
