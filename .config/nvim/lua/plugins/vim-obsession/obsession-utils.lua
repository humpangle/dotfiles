local utils = require("utils")
local m = {}

m.get_session_file = function()
  local suffix = utils.get_os_env_or_nil("NVIM_SESSION_NAME_SUFFIX")

  if suffix then
    return "session-" .. suffix
  end

  return "session"
end
m.get_session_path_relative = function()
  return vim.fn.fnamemodify(vim.v.this_session, ":.")
end

return m
