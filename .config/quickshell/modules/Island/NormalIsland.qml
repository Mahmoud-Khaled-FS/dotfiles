import QtQuick
import QtQuick.Layouts
import "./widgets"

Item {
    id: root
    implicitWidth: row.implicitWidth + 40 // 20 left + 20 right

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 30

        RowLayout {
            Workspaces {}
        }
        RowLayout {
            Clock {}
        }
        RowLayout {
            Volume {}
            KeyboardLayout {}
        }
    }
}
