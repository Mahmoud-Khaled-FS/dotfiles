
local mainMod = "SUPER"

function mkey(key)
  return mainMod .. " + " .. key
end

function mskey(key)
  return mainMod .. " + SHIFT + " .. key
end

function makey(key)
  return mainMod .. " + ALT + " .. key
end

function mckey(key)
  return mainMod .. " + CTRL + " .. key
end