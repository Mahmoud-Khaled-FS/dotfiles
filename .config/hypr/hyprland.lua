require("modules.helpers")
require("modules.monitors")
require("modules.env")
require("modules.autostart")

package.path = package.path .. ";./?.lua;./?/init.lua"

SMW = require("plugins.split-monitor-workspaces")

SMW.setup({
    workspace_count = 5,
})

require("modules.rules")
require("modules.autostart")
require("modules.layouts")
require("modules.bindings.keybinds")
require("modules.ui")
require("modules.animations")
require("modules.misc")
require("modules.inputs")
