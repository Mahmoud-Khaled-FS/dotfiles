local awful = require("awful")

local constant = require("main.constant")

awful.spawn.with_shell(constant.config_dir .. "scripts/autostart.sh")
