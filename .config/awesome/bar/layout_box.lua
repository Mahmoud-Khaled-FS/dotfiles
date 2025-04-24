local awful = require("awful")
local gears = require("gears")

function create_layout_box(s)
    local layout_box = awful.widget.layoutbox(s)

    layout_box:buttons(gears.table.join(awful.button({}, 1, function()
        awful.layout.inc(1)
    end), awful.button({}, 3, function()
        awful.layout.inc(-1)
    end)))

    return layout_box
end

return create_layout_box
