local gears = require("gears")
local awful = require("awful")

local constant = require("main.constant")
local modkey = constant.modkey

local killClient = awful.key({modkey}, "q", function(c)
    c:kill()
end, {
    description = "close",
    group = "client"
})

local fullscreenKey = awful.key({modkey}, "f", function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
end, {
    description = "toggle fullscreen",
    group = "client"
})

local floatingToggle = awful.key({modkey, "shift"}, "f", awful.client.floating.toggle, {
    description = "toggle floating",
    group = "client"
})

local moveToMaster = awful.key({modkey}, "m", function(c)
    c:swap(awful.client.getmaster())
end, {
    description = "move to master",
    group = "client"
})

local moveToScreen = awful.key({modkey}, "o", function(c)
    c:move_to_screen()
end, {
    description = "move to screen",
    group = "client"
})

local alwaysOnTop = awful.key({modkey}, "t", function(c)
    c.ontop = not c.ontop
end, {
    description = "toggle keep on top",
    group = "client"
})

local clientkeys = gears.table.join(fullscreenKey, killClient, floatingToggle, moveToMaster, moveToScreen, alwaysOnTop)

return clientkeys
