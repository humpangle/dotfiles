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
  kitty.toggle_quick_access()
end)

hs.loadSpoon("AClock")
spoon.AClock.format = "%Y-%m-%d\n%H:%M %a"
spoon.AClock.textSize = 72
spoon.AClock.width = 520
spoon.AClock.height = 200
with_leader_key:bind("alt", "t", function()
  spoon.AClock:toggleShow()
  -- spoon.AClock:toggleShowPersistent()
end)
