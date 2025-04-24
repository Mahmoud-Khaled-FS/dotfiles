local wibox = require("wibox")
local awful = require("awful")

return {
    time_date = wibox.widget {
        format = "%a %d %b %I:%M %p ",
        widget = wibox.widget.textclock
    },
    prompt = awful.widget.prompt(),
    systray = wibox.widget.systray()
}
