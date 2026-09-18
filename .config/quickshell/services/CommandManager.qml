pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root
    property var _commands: [
        {
            name: "App Launcher",
            run: () => {
                IslandManager.toggleMode(IslandManager.AppLauncher);
            }
        },
        {
            name: "Test Notification",
            run: () => {
                Quickshell.execDetached(["notify-send", "test"]);
            }
        },
        {
            name: "Clear Notifications",
            run: () => {
                NotificationManager.clearAll();
            }
        }
    ]

    function commands(search) {
        if (search) {
            return _commands.filter(c => c.name.toLowerCase().includes(search.toLowerCase()));
        }
        return _commands;
    }

    function countCommands() {
        return _commands.length;
    }
}
