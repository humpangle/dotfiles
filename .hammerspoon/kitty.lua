local M = {}

-- Adjust if installed elsewhere
local KITTY = "/Applications/kitty.app/Contents/MacOS/kitty"
local KITTEN = "/Applications/kitty.app/Contents/MacOS/kitten"

-- Must match your quick-access-terminal.conf
local SOCKET = "unix:/tmp/kitty-ebnis.sock"

-- Run `kitty @` against the quick-access instance; return stdout on success, or nil on failure
local function kitty_at(args)
  local parts = { string.format("%q", KITTY), "@", "--to", SOCKET }
  for _, a in ipairs(args) do
    table.insert(parts, a)
  end
  local cmd = table.concat(parts, " ")
  local out, success = hs.execute(cmd, true) -- blocking; capture stdout/stderr
  if not success or not out or out == "" then
    return nil
  end
  return out
end

function M.launch_quick_access()
  hs.task
    .new(KITTEN, function() end, {
      "quick-access-terminal",
      "--instance-group",
      "quick-access",
      "--detach",
    })
    :start()
end

-- Is the quick-access instance up? (socket responds and has at least one window)
local function instance_is_up()
  local out = kitty_at({ "ls" })
  if not out then
    return false
  end
  local ok, data = pcall(hs.json.decode, out)
  if not ok or type(data) ~= "table" or not data.os_windows then
    return false
  end
  return #data.os_windows > 0
end

-- Bring quick-access to the foreground (or launch if not running)
function M.raise_quick_access()
  if instance_is_up() then
    kitty_at({ "focus-window", "--match", "recent:0" })
  else
    M.launch_quick_access()
  end
end

-- Toggle: if running -> hide (close all windows in that instance); else -> launch
function M.toggle_quick_access()
  if instance_is_up() then
    kitty_at({ "close-window", "--match", "all" })
  else
    M.launch_quick_access()
  end
end

return M
