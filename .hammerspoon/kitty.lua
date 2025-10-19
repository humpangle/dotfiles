local m = {}

local KITTY_BUNDLE = "net.kovidgoyal.kitty"

-- Minimize all current Kitty windows; returns true if any were minimized
local function minimizeKittyWindows()
  local app = hs.application.get(KITTY_BUNDLE)
    or hs.appfinder.appFromBundleID(KITTY_BUNDLE)
  if not app then
    return false
  end
  local any = false
  for _, w in ipairs(app:allWindows()) do
    if w:isStandard() and not w:isMinimized() then
      w:minimize()
      any = true
    end
  end
  return any
end

local function isKittyRunning(mm)
  if hs.application.find(KITTY_BUNDLE) then
    if mm then
      minimizeKittyWindows()
    end

    return true
  end

  return false
end

-- Launch Kitty in the background (no focus change)
local function launchKittyInBackground()
  -- -g = do not bring to front;
  -- -b = launch by bundle id
  hs.task
    .new("/usr/bin/open", nil, {
      "-g",
      "-b",
      KITTY_BUNDLE,
    })
    :start()
end

-- Ensure Kitty is running;
-- if not, launch in background then proceed
function m.ensure_kitty_launched(thenDo)
  if isKittyRunning() then
    thenDo()
    return
  end

  launchKittyInBackground()

  -- Wait for the app to be alive (up to ~3s)
  local waited = 0
  hs.timer.doUntil(function()
    waited = waited + 0.05
    return isKittyRunning("minimize") or waited > 3.0
  end, function()
    if isKittyRunning("minimize") then
      thenDo()
    else
      hs.alert.show("Kitty did not start (timeout).")
    end
  end, 0.05)
end

-- Toggle a named quick-access terminal; add --keep-focus if you like
function m.toggle_quick_access()
  local kitten_bin = "/Applications/kitty.app/Contents/MacOS/kitten"
  -- local kitty = "/Applications/kitty.app/Contents/MacOS/kitten"
  hs.task
    .new(kitten_bin, function() end, {
      "quick-access-terminal",
      "--instance-group", -- name of quick-access-terminal is `quick-access`.
      "quick-access",
      "--detach", -- detach from parent and kill parent
    })
    :start()
end

return m
