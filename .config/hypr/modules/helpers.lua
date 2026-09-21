local constant = require "modules.constant"

function mkey(key)
  return constant.mainMod .. " + " .. key
end

function mskey(key)
  return constant.mainMod .. " + SHIFT + " .. key
end

function makey(key)
  return constant.mainMod .. " + ALT + " .. key
end

function mckey(key)
  return constant.mainMod .. " + CTRL + " .. key
end

function noctalia_ipc(command)
  return constant.noctalia_ipc .. command
end