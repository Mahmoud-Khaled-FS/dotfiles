-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

hl.window_rule({
  match = { class = "blueman-manager" },
  float = true,
  size  = { "monitor_w * 0.4", "monitor_h * 0.5" }
})

hl.window_rule({
  match = { class = "floating" },
  float = true,
  size  = { "monitor_w * 0.4", "monitor_h * 0.5" }
})

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})


hl.window_rule({
    name = "zen",
    match = { class = "zen" },
    workspace = 6,
})

hl.window_rule({
    name = "code",
    match = { class = "code" },
    workspace = 3,
})

hl.window_rule({
    name = "flameshot-multi-display-fix",
    match = { class = "flameshot" },
    animation = "fade",
    rounding = 0,
    border_size = 0,
    float = true,
    pin = true,
    move = { -1920, 0 },
    size = { 4480, 1440 },
})