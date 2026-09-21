-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/

local theme = require("themes.catppuccin-mocha")

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 10,
        border_size = 1,
        col = {
            active_border   = { colors = { theme.red, theme.pink }, angle = 60 },
            inactive_border = theme.surface0,
        },
        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true,
        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,
    },

    decoration = {
        rounding       = 0,
        rounding_power = 0,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        
        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = theme.mantle,
        },

        blur = {
            enabled   = true,
            size      = 10,
            passes    = 3,
            ignore_opacity = true,
            noise = 0.08,
            contrast  = 2,
            xray = false,
            new_optimizations = true,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})
