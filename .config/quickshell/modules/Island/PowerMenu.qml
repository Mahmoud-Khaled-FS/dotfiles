import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.services

FocusScope {
    id: root
    clip: true

    property int currentIndex: 0

    property string powerScriptPath: Quickshell.env("HOME") + "/.config/quickshell/scripts/power.sh"

    function requestAction(command, description) {
        var scriptPath = root.powerScriptPath;
        IslandManager.showConfirmation("Are you sure you want to " + description + "?", function() {
            Quickshell.execDetached([scriptPath, command]);
        });
    }

    function executeSelected() {
        switch (currentIndex) {
        case 0:
            requestAction("poweroff", "power off");
            break;
        case 1:
            requestAction("reboot", "restart");
            break;
        case 2:
            requestAction("lock-session", "lock the session");
            break;
        }
    }

    Keys.onLeftPressed: {
        currentIndex = Math.max(0, currentIndex - 1);
    }

    Keys.onRightPressed: {
        currentIndex = Math.min(2, currentIndex + 1);
    }

    Keys.onReturnPressed: executeSelected()
    Keys.onEnterPressed: executeSelected()
    Keys.onEscapePressed: IslandManager.close()

    Component.onCompleted: {
        root.forceActiveFocus();
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 14

        PowerButton {
            Layout.fillWidth: true
            Layout.fillHeight: true

            icon: "󰐥"
            label: "Power off"
            danger: true
            selected: root.currentIndex === 0

            onHovered: root.currentIndex = 0
            onClicked: root.requestAction("poweroff", "power off")
        }

        PowerButton {
            Layout.fillWidth: true
            Layout.fillHeight: true

            icon: "󰜉"
            label: "Restart"
            selected: root.currentIndex === 1

            onHovered: root.currentIndex = 1
            onClicked: root.requestAction("reboot", "restart")
        }

        PowerButton {
            Layout.fillWidth: true
            Layout.fillHeight: true

            icon: "󰌾"
            label: "Lock"
            selected: root.currentIndex === 2

            onHovered: root.currentIndex = 2
            onClicked: root.requestAction("lock-session", "lock the session")
        }
    }

    component PowerButton: Rectangle {
        id: button

        required property string icon
        required property string label
        required property bool selected
        property bool danger: false

        signal clicked
        signal hovered

        radius: 18

        color: selected || mouseArea.containsMouse ? "#181825" : "#1e1e2e"

        border.width: 1
        border.color: selected ? (danger ? "#f38ba8" : "#cdd6f4") : "#585b70"

        scale: mouseArea.pressed ? 0.94 : selected || mouseArea.containsMouse ? 1.03 : 1

        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }

        Behavior on border.color {
            ColorAnimation {
                duration: 100
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: 120
                easing.type: Easing.OutCubic
            }
        }

        Column {
            anchors.centerIn: parent
            spacing: 5

            Text {
                anchors.horizontalCenter: parent.horizontalCenter

                text: button.icon
                color: button.danger ? "#f38ba8" : "#fafafa"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 29
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter

                text: button.label
                color: button.selected ? "#fafafa" : "#a1a1aa"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 11
            }
        }

        MouseArea {
            id: mouseArea

            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onEntered: button.hovered()
            onClicked: button.clicked()
        }
    }
}
