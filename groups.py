from libqtile.config import Group, Match

def new():
  return [
    Group('1' ,matches=[Match(wm_class="Alacritty"), Match(wm_class="kitty")]),
    Group('2', matches=[Match(wm_class='Google-chrome'),Match(wm_class='chromium'), Match(wm_class='firefox')]),
    Group('3', matches=[Match(wm_class='Code'),Match(wm_class="Geany") ,Match(wm_class="Emacs")]),
    Group('4', matches=[Match(wm_class="Thunar")]),
    Group('5'),
    Group('6'),
    Group('7'),
    Group('8'),
    Group('9'),
  ]