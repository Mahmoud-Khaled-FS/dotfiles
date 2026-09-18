pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland

QtObject {
    id: monitor_manager

    readonly property string mainMonitor: "DP-1"

    function isMain(screen) {
        return screen?.name === mainMonitor;
    }

    function type(screen) {
        return isMain(screen) ? "main" : "secondary";
    }

    function isFocus(screen) {
        return Hyprland.focusedMonitor?.name == screen.name;
    }
}
