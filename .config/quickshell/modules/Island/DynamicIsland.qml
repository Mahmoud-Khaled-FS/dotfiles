import QtQuick
import qs.services
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Services.Notifications

Rectangle {
    id: root

    required property var screen

    color: "#11111b"
    radius: 5

    border.width: 1
    border.color: "#11111b"
    anchors.topMargin: 5

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    clip: true

    width: normalWidth
    height: 32

    property var normalWidth: 120

    Connections {
        target: loader.item

        function onImplicitWidthChanged() {
            if (IslandManager.modeForScreen(root.screen) === IslandManager.Normal && loader.item && loader.item.implicitWidth > 0) {
                root.normalWidth = loader.item.implicitWidth;
            }
        }
    }

    states: [
        State {
            name: "normal"
            when: IslandManager.canShowMode(root.screen, IslandManager.Normal)

            PropertyChanges {
                root.width: root.normalWidth
                root.height: 30
            }
        },
        State {
            name: "appLauncher"
            when: IslandManager.canShowMode(root.screen, IslandManager.AppLauncher)

            PropertyChanges {
                root.width: 560
                root.height: 300
            }
        },
        State {
            name: "powerMenu"
            when: IslandManager.canShowMode(root.screen, IslandManager.PowerMenu)

            PropertyChanges {
                root.width: 460
                root.height: 100
            }
        },
        State {
            name: "confirmation"
            when: IslandManager.canShowMode(root.screen, IslandManager.Confirmation)

            PropertyChanges {
                root.width: 420
                root.height: 120
            }
        },
        State {
            name: "notificationPopup"
            when: IslandManager.canShowMode(root.screen, IslandManager.NotificationPopup)

            PropertyChanges {
                root.width: 300
                root.height: 50
            }
        },
        State {
            name: "controlCenter"
            when: IslandManager.canShowMode(root.screen, IslandManager.ControlCenter)

            PropertyChanges {
                root.width: 930
                root.height: 330
            }
        },
        State {
            name: "commandPalette"
            when: IslandManager.canShowMode(root.screen, IslandManager.CommandPalette)

            PropertyChanges {
                root.width: 560
                root.height: 300
            }
        }
    ]

    transitions: Transition {
        NumberAnimation {
            properties: "implicitWidth,implicitHeight,width,height,redius"
            duration: 250
            easing.type: Easing.OutQuart
        }
    }

    Loader {
        id: loader
        anchors.fill: parent

        opacity: 0

        onLoaded: {
            fadeIn.restart();
        }

        NumberAnimation {
            id: fadeIn
            target: loader
            property: "opacity"
            from: 0
            to: 1
            duration: 250
            easing.type: Easing.OutCubic
        }

        sourceComponent: {
            switch (IslandManager.modeForScreen(root.screen)) {
            case IslandManager.AppLauncher:
                return launcherView;
            case IslandManager.PowerMenu:
                return powerMenu;
            case IslandManager.Confirmation:
                return confirmation;
            case IslandManager.NotificationPopup:
                return notificationPopup;
            case IslandManager.ControlCenter:
                return controlCenter;
            case IslandManager.CommandPalette:
                return commandPalette;
            default:
                return normalView;
            }
        }
    }

    Component {
        id: normalView

        NormalIsland {
            id: normalIsland
        }
    }

    Component {
        id: launcherView

        AppLauncher {}
    }

    Component {
        id: powerMenu

        PowerMenu {}
    }

    Component {
        id: confirmation

        Confirmation {
            message: IslandManager.confirmationMessage

            onAccepted: IslandManager.acceptConfirmation()
            onRejected: IslandManager.rejectConfirmation()
        }
    }

    Component {
        id: notificationPopup

        NotificationPopup {}
    }

    Component {
        id: controlCenter

        ControlCenter {}
    }

    Component {
        id: commandPalette

        CommandPalette {}
    }
}
