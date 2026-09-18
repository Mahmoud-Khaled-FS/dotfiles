-- Application bindings
local constant = require "modules.constant"

hl.bind(mkey("Return"), hl.dsp.exec_cmd(constant.terminal))

hl.bind(mskey("S"), hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot.sh select"))

hl.bind(mkey("D"), hl.dsp.exec_cmd("qs ipc call appLauncher toggle"))
hl.bind(mkey("X"), hl.dsp.exec_cmd("qs ipc call powerMenu toggle"))
hl.bind(mkey("I"), hl.dsp.exec_cmd("qs ipc call controlCenter toggle"))
hl.bind(mkey("P"), hl.dsp.exec_cmd("qs ipc call commandPalette toggle"))
hl.bind(mkey("R"), hl.dsp.exec_cmd("~/.config/rofi/rofi_run.sh"))
hl.bind(mkey("V"), hl.dsp.exec_cmd("~/.config/rofi/rofi_clipboard.sh"))
