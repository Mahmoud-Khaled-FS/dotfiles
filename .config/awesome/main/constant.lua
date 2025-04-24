local gears = require("gears")

local config_dir = gears.filesystem.get_configuration_dir()
local Constant = {
    terminal = "kitty",
    editor = "nvim",
    modkey = "Mod4",

    config_dir = config_dir,
    theme_dir = config_dir .. "themes/",
    active_theme = config_dir .. "themes/" .. "rose_pine.lua",

    tags = {
        names = {"[I]", "[II]", "[III]", "[IV]", "[V]", "[VI]", "[VII]", "[VIII]", "[IX]"}
    }
}

return Constant
