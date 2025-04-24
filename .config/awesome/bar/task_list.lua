local gears = require("gears")
local awful = require("awful")

function create_tasklist(s)
    return awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags
    }
end

return create_tasklist
