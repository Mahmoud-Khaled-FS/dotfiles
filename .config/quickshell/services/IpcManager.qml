import QtQuick
import Quickshell
import Quickshell.Io

import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Services.Notifications

Item {

    IpcHandler {
        target: "appLauncher"
        function toggle(): void {
            IslandManager.toggleMode(IslandManager.AppLauncher);
        }
    }

    IpcHandler {
        target: "powerMenu"
        function toggle(): void {
            IslandManager.toggleMode(IslandManager.PowerMenu);
        }
    }

    IpcHandler {
        target: "controlCenter"
        function toggle(): void {
            IslandManager.toggleMode(IslandManager.ControlCenter);
        }
    }

    IpcHandler {
        target: "commandPalette"
        function toggle(): void {
            IslandManager.toggleMode(IslandManager.CommandPalette);
        }
    }
}
