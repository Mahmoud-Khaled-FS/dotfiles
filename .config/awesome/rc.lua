pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local constant = require("main.constant")

require("awful.hotkeys_popup.keys")

require('main.error_handling')

beautiful.init(constant.active_theme)

awful.layout.layouts = require("main.layout")

-- Notification library
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

require('main.screens')

local mouseButtons = require('binding.mouse_binding')
root.buttons(mouseButtons)

local globalkeys = require('binding.global_keys')
root.keys(globalkeys)

awful.rules.rules = require('main.rules')

require('main.signals')

require('main.autostart')

package.loaded['naughty.dbus'] = {}
