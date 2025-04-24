local awful = require("awful")
local wibox = require("wibox")

local appearance = {
    tag_buttons = require('bar.tag_buttons'),
    task_list = require('bar.task_list'),
    widgets = require('bar.widgets'),
    layout_box = require('bar.layout_box'),
    keyboard_layout = require('bar.keyboard_layout'),
    wirelessStatus = require('bar.wireless_status')
}

function setup_bar(s)
    local mywibox = awful.wibar({
        position = "top",
        screen = s
    })

    local leftWidget = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        appearance.tag_buttons(s),
        appearance.layout_box(s)
    }

    local centerWidget = appearance.task_list(s)

    local rightWidget = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        appearance.wirelessStatus.widget,
        appearance.keyboard_layout(s),
        appearance.widgets.systray,
        appearance.widgets.time_date
    }

    mywibox:setup{
        layout = wibox.layout.align.horizontal,
        leftWidget,
        centerWidget,
        rightWidget
    }
end

return setup_bar
