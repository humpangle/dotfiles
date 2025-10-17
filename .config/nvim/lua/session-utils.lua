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

m.get_all_session_files = function()
  local pattern = m.get_session_file() .. "*.vim"
  local session_files = vim.fn.glob(pattern, false, true)

  if #session_files == 0 then
    return nil, nil
  end

  -- Sort files by modification time (newest first)
  table.sort(session_files, function(a, b)
    local a_time = vim.fn.getftime(a)
    local b_time = vim.fn.getftime(b)
    return a_time > b_time
  end)

  return session_files, pattern
end

return m
