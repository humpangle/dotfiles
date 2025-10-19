local m = {}

-- Make F18 act like a modifier by entering/leaving a modal while held
local leader_key_code = hs.keycodes.map.F18
local with_leader_key = hs.hotkey.modal.new()

-- Optional: ignore key-repeat noise
local function isAutoRepeat(e)
  return (
    e:getProperty(hs.eventtap.event.properties.keyboardEventAutorepeat) or 0
  ) ~= 0
end

-- Enter modal on F18 down; swallow the event so the OS never sees "F18"
local f18DownTap = hs.eventtap.new(
  { hs.eventtap.event.types.keyDown },
  function(e)
    if e:getKeyCode() == leader_key_code and not isAutoRepeat(e) then
      with_leader_key:enter()
      return true
    end
  end
)

-- Exit modal on F18 up; swallow the event
local f18UpTap = hs.eventtap.new({ hs.eventtap.event.types.keyUp }, function(e)
  if e:getKeyCode() == leader_key_code then
    with_leader_key:exit()
    return true
  end
end)

f18DownTap:start()
f18UpTap:start()

-- https://github.com/evantravers/hammerspoon-config/blob/abc945264a4ec1830083c53079b2bfd5c4a4d23d/hyper.lua#L25
hs.hotkey.bind({}, leader_key_code, function()
  with_leader_key:enter()
end, function ()
  with_leader_key:exit()
end)

m.with_leader_key = with_leader_key
return m
