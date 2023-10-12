from libqtile.config import Key, Group
from libqtile.lazy import lazy

def new(terminal: str, groups: list[Group]):
  mod = "mod4"
  shift = 'shift'
  ctrl = 'control'
  keys= [
    # Qtile
    Key([mod, ctrl, shift], "r", lazy.reload_config(),      desc="Reload the config"),
    Key([mod, ctrl, shift], "q", lazy.shutdown(),           desc="Shutdown Qtile"),
    Key([mod], "r",              lazy.spawncmd(),           desc="Spawn a command using a prompt widget"),

    # Window
    Key([mod], "q",             lazy.window.kill(),         desc="Kill focused window"),
    # Focus Widnow            
    Key([mod], "h",             lazy.layout.left(),         desc="Move focus to left"),
    Key([mod], "l",             lazy.layout.right(),        desc="Move focus to right"),
    Key([mod], "j",             lazy.layout.down(),         desc="Move focus down"),
    Key([mod], "k",             lazy.layout.up(),           desc="Move focus up"),
    Key([mod], "Left",          lazy.layout.left(),         desc="Move focus to left"),
    Key([mod], "Right",         lazy.layout.right(),        desc="Move focus to right"),
    Key([mod], "Down",          lazy.layout.down(),         desc="Move focus down"),
    Key([mod], "Up",            lazy.layout.up(),           desc="Move focus up"),
    # Move Focus Window
    Key([mod, shift], "h",      lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, shift], "l",      lazy.layout.shuffle_right(),desc="Move window to the right"),
    Key([mod, shift], "j",      lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, shift], "k",      lazy.layout.shuffle_up(),   desc="Move window up"),
    Key([mod, shift], "Left",   lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, shift], "Right",  lazy.layout.shuffle_right(),desc="Move window to the right"),
    Key([mod, shift], "Down",   lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, shift], "Up",     lazy.layout.shuffle_up(),   desc="Move window up"),

    Key([mod], "tab",           lazy.layout.next(),         desc="Move window focus to other window"),
    
    Key([mod, ctrl], "Left",    lazy.layout.decrease_ratio(),    desc="Grow window to the left"),
    Key([mod, ctrl], "Right",   lazy.layout.increase_ratio(),   desc="Grow window to the right"),
    Key([mod, ctrl], "u",       lazy.layout.reset(),    desc="Reset all window sizes"),
    
    # Layout
    Key([mod], "space", lazy.next_layout(), desc="Toggle between layouts"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod, shift], 'f', lazy.window.toggle_floating(), desc="Toggle floating on the focused window",),

    # Apps
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod, shift], 'Return', lazy.spawn(terminal), desc="Launch terminal in floating mode")
  ]

  for i in groups:
    keys.extend(
        [
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
        ]
    )

  return keys
