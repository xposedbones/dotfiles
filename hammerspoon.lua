-- Settings
-----------------------------------------------------------------------------------------
local hyper = { "cmd", "alt", "ctrl", "shift" }

hs.logger.defaultLogLevel = 'info'
log = hs.logger.new('WM', 'debug')
-----------------------------------------------------------------------------------------


-- Auto Reload
-----------------------------------------------------------------------------------------
function reload_config(files)
  hs.reload()
end

hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reload_config):start()
hs.alert.show('HS Reloaded 🎉')
-----------------------------------------------------------------------------------------


-- Hypershift + I to inspect a window
hs.hotkey.bind(hyper, "i", function()
  local w = hs.window.focusedWindow()
  hs.console.clearConsole()
  log.d("===============================================================")
  log.d("Debugging :: ", w:application():name())
  log.d("===============================================================")
  log.d("Application Name:", w:application():name())
  log.d("Id:", w:id())
  log.d("Title:", w:title())
  log.d("TopLeft:", w:topLeft())
  log.d("Size:", w:size())
  log.d("isFullScreen:", w:isFullScreen())
  log.d("Frame:", w:frame())
  log.d("Role:", w:role())
  log.d("Subrole:", w:subrole())
end)


function moveWindowToScreen(screen, x, y, w, h, useOffset)
  local win = hs.window.focusedWindow()
  local displays = hs.screen.allScreens();

  if useOffset == true then
    local offset = displays[screen]:localToAbsolute({ x = x, y = y })
    log.d("Offset:", offset)
    x = x + offset.x
    y = y + offset.y
  end

  win:moveToScreen(displays[screen], true, true)
  win:setFrame({ x = x, y = y, w = w, h = h })
end

hs.hotkey.bind({ 'ctrl', 'cmd' }, 'left', function()
  moveWindowToScreen(1, 0, 0, 3440 - 1920, 1364)
  -- moveWindowToScreen(1, 0, 0, 1920, 1416)
end)

hs.hotkey.bind({ 'ctrl', 'cmd', 'shift' }, 'left', function()
  moveWindowToScreen(1, 0, 0, 2221, 1364)
end)

hs.hotkey.bind({ 'ctrl', 'cmd' }, 'right', function()
  moveWindowToScreen(1, 3440 - 1920, 0, 1920, 1364)
  -- moveWindowToScreen(1, 1920, 0, 3440 - 1920, 1416)
end)

hs.hotkey.bind({ 'ctrl', 'cmd', 'shift' }, 'right', function()
  moveWindowToScreen(1, 2221, 0, 3440 - 2221, 1364)
end)

hs.hotkey.bind({ 'ctrl', 'cmd' }, 'up', function()
  moveWindowToScreen(2, 0, 13, 1080, 719, true)
end)

hs.hotkey.bind({ 'ctrl', 'cmd' }, 'down', function()
  moveWindowToScreen(2, 0, 375, 1080, 1177, true)
end)

-- Volume

local function sendSystemKey(key)
  hs.eventtap.event.newSystemKeyEvent(key, true):post()
  hs.eventtap.event.newSystemKeyEvent(key, false):post()
end

local volume = {
  up   = function() sendSystemKey('SOUND_UP') end,
  down = function() sendSystemKey('SOUND_DOWN') end,
  mute = function() sendSystemKey('MUTE') end
}

local media = {
  playpause = function() sendSystemKey('PLAY') end,
  next = function() sendSystemKey('NEXT') end,
  prev = function() sendSystemKey('PREVIOUS') end
}

hs.hotkey.bind(hyper, 'a', volume.down, nil, volume.down)
hs.hotkey.bind(hyper, 'd', volume.up, nil, volume.up)
-- hs.hotkey.bind(hyper, 's', volume.mute)

hs.hotkey.bind(hyper, 'q', media.prev)
hs.hotkey.bind(hyper, 'w', media.playpause)
hs.hotkey.bind(hyper, 'e', media.next)
