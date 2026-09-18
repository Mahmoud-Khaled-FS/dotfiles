import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets

Scope {
    id: root

    property bool open: false
    property int selectedIndex: 0
    property string query: ""
    property var applications: []
    property var filteredApplications: []

    function filterApplications(query) {
        const needle = query.trim().toLowerCase();
        root.filteredApplications = root.applications.filter(app => !needle || app.name.toLowerCase().includes(needle) || app.desktop.toLowerCase().includes(needle));
        root.selectedIndex = root.filteredApplications.length > 0 ? 0 : -1;
    }

    function select(offset) {
        if (root.filteredApplications.length === 0)
            return;

        root.selectedIndex = (root.selectedIndex + offset + root.filteredApplications.length) % root.filteredApplications.length;
    }

    function launch(index) {
        if (index < 0 || index >= root.filteredApplications.length)
            return;

        Quickshell.execDetached(["gio", "launch", root.filteredApplications[index].path]);
        root.open = false;
    }

    IpcHandler {
        target: "launcher"

        function toggle() {
            root.open = !root.open;
        }
    }

    Process {
        id: applicationLoader
        command: ["sh", "-c", "for directory in \"${XDG_DATA_HOME:-$HOME/.local/share}/applications\" /usr/local/share/applications /usr/share/applications; do [ -d \"$directory\" ] && find \"$directory\" -maxdepth 1 -type f -name '*.desktop' -print; done | while IFS= read -r desktop; do grep -qx 'Hidden=true' \"$desktop\" && continue; grep -qx 'NoDisplay=true' \"$desktop\" && continue; name=$(grep -m1 '^Name=' \"$desktop\" | cut -d= -f2-); icon=$(grep -m1 '^Icon=' \"$desktop\" | cut -d= -f2-); [ -n \"$name\" ] && printf '%s\\037%s\\037%s\\n' \"$name\" \"$icon\" \"$desktop\"; done | LC_ALL=C sort -f"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                const fields = data.split("\u001f");
                if (fields.length !== 3)
                    return;

                root.applications = root.applications.concat([
                    {
                        name: fields[0],
                        icon: fields[1],
                        path: fields[2],
                        desktop: fields[2].split("/").pop().replace(/\.desktop$/, "")
                    }
                ]);
            }
        }

        onExited: root.filterApplications(root.query)
    }

    PanelWindow {
        id: window
        required property var modelData
        screen: modelData
        visible: root.open
        color: "#00000000"

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
        onVisibleChanged: if (visible)
            focusTimer.restart()

        Timer {
            id: focusTimer
            interval: 1
            onTriggered: search.forceActiveFocus()
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.open = false
        }

        Rectangle {
            id: launcher
            width: Math.round(window.width * 0.3)
            height: content.implicitHeight + 36
            anchors.centerIn: parent
            radius: 14
            color: "#11111b"
            border.color: "#45475a"
            border.width: 1

            Column {
                id: content
                anchors.fill: parent
                anchors.margins: 18
                spacing: 12

                Row {
                    width: parent.width
                    spacing: 8

                    Text {
                        text: "APPLICATIONS"
                        color: "#cdd6f4"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 14
                        font.bold: true
                    }

                    Text {
                        text: root.filteredApplications.length + " apps"
                        color: "#6c7086"
                        font.pixelSize: 13
                    }
                }

                TextField {
                    id: search
                    width: parent.width
                    height: 30
                    placeholderText: "Search applications..."
                    color: "#cdd6f4"
                    placeholderTextColor: "#7f849c"
                    font.pixelSize: 14
                    leftPadding: 18
                    rightPadding: 18
                    verticalAlignment: TextInput.AlignVCenter
                    selectByMouse: true
                    text: root.query
                    background: Rectangle {
                        radius: 9
                        color: "#181825"
                        border.color: search.activeFocus ? "#89b4fa" : "#1e1e2e"
                        border.width: 1
                    }

                    onTextChanged: root.query = text
                    onAccepted: root.launch(root.selectedIndex)
                    Keys.onPressed: event => {
                        if (event.key === Qt.Key_Down) {
                            root.select(1);
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Up) {
                            root.select(-1);
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Escape) {
                            root.open = false;
                            event.accepted = true;
                        }
                    }
                }

                ListView {
                    id: results
                    width: parent.width
                    height: 9 * 52
                    clip: true
                    model: root.filteredApplications
                    currentIndex: root.selectedIndex
                    spacing: 0

                    onCurrentIndexChanged: positionViewAtIndex(currentIndex, ListView.Contain)

                    delegate: Item {
                        id: row
                        required property var modelData
                        required property int index
                        width: results.width
                        height: 52

                        Rectangle {
                            anchors.fill: parent
                            radius: 8
                            color: row.index === root.selectedIndex ? "#45475a" : "transparent"
                        }

                        IconImage {
                            id: icon
                            anchors.left: parent.left
                            anchors.leftMargin: 12
                            anchors.verticalCenter: parent.verticalCenter
                            width: 28
                            height: 28
                            source: Quickshell.iconPath(row.modelData.icon, "application-x-executable")
                        }

                        Column {
                            anchors.left: icon.right
                            anchors.leftMargin: 12
                            anchors.right: parent.right
                            anchors.rightMargin: 12
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2

                            Text {
                                width: parent.width
                                text: row.modelData.name
                                color: "#cdd6f4"
                                font.pixelSize: 14
                                elide: Text.ElideRight
                            }

                            Text {
                                width: parent.width
                                text: row.modelData.desktop
                                color: "#7f849c"
                                font.pixelSize: 12
                                elide: Text.ElideRight
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: root.selectedIndex = row.index
                            onClicked: root.launch(row.index)
                        }
                    }

                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                    }
                }
            }
        }
    }
    onOpenChanged: {
        if (root.open) {
            root.filterApplications(root.query);
        } else {
            root.query = "";
        }
    }

    onQueryChanged: root.filterApplications(root.query)
}
