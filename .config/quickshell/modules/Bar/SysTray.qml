import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: tray
    spacing: 4

    Repeater {
        model: SystemTray.items

        delegate: Item {
            id: trayItem
            required property var modelData

            implicitWidth: 18
            implicitHeight: 18

            IconImage {
                anchors.fill: parent
                source: trayItem.modelData.icon
            }

            QsMenuAnchor {
                id: menu
                menu: trayItem.modelData.menu
                anchor.window: tray.Window.window
                anchor.item: trayItem
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton) {
                        if (trayItem.modelData.onlyMenu)
                            menu.open();
                        else
                            trayItem.modelData.activate();
                    } else if (mouse.button === Qt.MiddleButton) {
                        trayItem.modelData.secondaryActivate();
                    } else if (trayItem.modelData.hasMenu) {
                        menu.open();
                    }
                }
            }
        }
    }
}
