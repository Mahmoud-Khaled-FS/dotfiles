pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root
    property var _apps: []
    property bool loaded: false
    property bool loading: false

    function loadApps() {
        let list = [];
        let entries = DesktopEntries.applications.values;
        for (let i = 0; i < entries.length; i++) {
            let e = entries[i];
            list.push({
                name: e.name,
                comment: e.comment || "",
                icon: e.icon,
                entry: e
            });
        }
        _apps = list.sort((a, b) => a.name.localeCompare(b.name));
    }

    Connections {
        target: DesktopEntries
        function onApplicationsChanged() {
            loadApps();
        }
    }

    function launch(app) {
        console.log(app);
        if (app.runInTerminal) {
            Quickshell.execDetached(["kitty", "-e", "sh", "-c", app.entry.command.join(" ")]);
            return;
        }
        app.entry.execute();
    }

    function apps(search) {
        if (search) {
            return _apps.filter(a => a.name.toLowerCase().includes(search.toLowerCase()) || a.comment.toLowerCase().includes(search.toLowerCase()));
        }
        return _apps;
    }

    function countApps() {
        return _apps.length;
    }
}
