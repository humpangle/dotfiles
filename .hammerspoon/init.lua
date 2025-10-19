hs = hs
spoon = spoon

local with_leader_key = require("with-leader-key").with_leader_key

-- Reload hammerspoon config
-- leader+alt+r
with_leader_key:bind("alt", "r", function()
  hs.reload()
end)
hs.alert.show("Hammerspoon Config   Reloaded")

local kitty = require("kitty")
-- Toggle kitty quick-access-terminal
with_leader_key:bind("", "space", function()
  kitty.ensure_kitty_launched(kitty.toggle_quick_access)
end)

-- Show the time
hs.loadSpoon("AClock")
with_leader_key:bind("alt", "t", function()
  spoon.AClock:toggleShow()
end)
