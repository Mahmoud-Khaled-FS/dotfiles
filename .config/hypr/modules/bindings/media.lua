local constant = require "modules.constant"

-- Volume 
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(constant.volumeScript .. " up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(constant.volumeScript .. " down"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd(constant.volumeScript .. " mute"),     { locked = true, repeating = true })

-- Microphone
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })

-- Brightness
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Keyboard Brightness
hl.bind("XF86KbdBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86KbdBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })
hl.bind("XF86KbdLightOnOff",    hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true })

-- Media
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Calculator
hl.bind("XF86Calculator", hl.dsp.exec_cmd(constant.calculator))

-- Home / Mail
hl.bind("XF86HomePage", hl.dsp.exec_cmd("xdg-open ~"), { locked = true })
hl.bind("XF86Mail", hl.dsp.exec_cmd("xdg-open https://mail.google.com"), { locked = true })

-- Search
hl.bind("XF86Search", hl.dsp.exec_cmd(constant.terminal), { locked = true })

-- Touchpad
hl.bind("XF86TouchpadToggle", hl.dsp.exec_cmd("kitty"), { locked = true })
hl.bind("XF86TouchpadOn", hl.dsp.exec_cmd("kitty"), { locked = true })
hl.bind("XF86TouchpadOff", hl.dsp.exec_cmd("kitty"), { locked = true })