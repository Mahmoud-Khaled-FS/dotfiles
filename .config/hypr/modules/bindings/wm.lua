local constant  = require "modules.constant"

-- Close
hl.bind(mkey("Q"), hl.dsp.window.close())
hl.bind(mckey("E"), hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

-- Layout
hl.bind(mkey("F"), hl.dsp.window.fullscreen({ action = "toggle", mode = 1 }))
hl.bind(mskey("F"), hl.dsp.window.float({ action = "toggle" }))

-- Master
hl.bind(mkey("M"), hl.dsp.layout("focusmaster"))  -- master only
hl.bind(mskey("M"), hl.dsp.layout("swapwithmaster"))  -- master only

-- Move focus with mainMod + arrow keys
hl.bind(mkey("left"),  hl.dsp.focus({ direction = "left" }))
hl.bind(mkey("right"), hl.dsp.focus({ direction = "right" }))
hl.bind(mkey("up"),    hl.dsp.focus({ direction = "up" }))
hl.bind(mkey("down"),  hl.dsp.focus({ direction = "down" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mkey("mouse:272"), hl.dsp.window.drag(),   { mouse = true })
hl.bind(mkey("mouse:273"), hl.dsp.window.resize(), { mouse = true })


for i = 1, SMW.get_amount_of_workspaces() do
    local n = tostring(i)
    if n == "10" then n = "0" end

    hl.bind(mkey(n), SMW.workspace(n))
    hl.bind(mskey(n), SMW.move_to_workspace_silent(n))
end

require "modules.bindings.media"