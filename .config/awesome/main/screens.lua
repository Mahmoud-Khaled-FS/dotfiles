local gears = require("gears")
local awful = require("awful")

local constant = require("main.constant")

local setup_bar = require('bar.bar')
awful.screen.connect_for_each_screen(function(s)
    awful.tag(constant.tags.names, s, awful.layout.layouts[1])

    s.mywibox = setup_bar(s)
end)
