-- Application bindings
local constant = require "modules.constant"

hl.bind(mkey("Return"), hl.dsp.exec_cmd(constant.terminal))

-- Screenshots
hl.bind(mskey("S"), hl.dsp.exec_cmd("noctalia msg screenshot-region"))
hl.bind(makey("S"), hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen"))

-- Panel
hl.bind(mkey("D"), hl.dsp.exec_cmd(noctalia_ipc("panel-toggle launcher")))
hl.bind(mkey("P"), hl.dsp.exec_cmd(noctalia_ipc("panel-toggle control-center")))
hl.bind(mkey("V"), hl.dsp.exec_cmd(noctalia_ipc("panel-toggle clipboard")))
hl.bind(mkey("X"), hl.dsp.exec_cmd(noctalia_ipc("panel-toggle session")))
-- hl.bind(mkey("X"), hl.dsp.exec_cmd(noctalia_ipc("panel-toggle session")))

hl.bind(mkey("comma"), hl.dsp.exec_cmd(noctalia_ipc("settings-toggle")))
hl.bind("ALT + Tab", hl.dsp.exec_cmd(noctalia_ipc("window-switcher")))

-- Custom Applications
hl.bind(mkey("B"), hl.dsp.exec_cmd(constant.browser))
hl.bind(mkey("E"), hl.dsp.exec_cmd(constant.fileManager))
