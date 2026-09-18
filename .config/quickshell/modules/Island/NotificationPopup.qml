import QtQuick
import QtQuick.Layouts
import qs.services

Item {
    id: root

    property var notification: NotificationManager.current

    anchors.fill: parent

    Behavior on opacity {
        NumberAnimation {
            duration: 150
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        spacing: 12

        Text {
            text: String.fromCodePoint(0xf0f3)
            color: "#FFFFFF"
            font {
                // family: Theme.nerdFontFamily
                pixelSize: 15
            }
            visible: notifIcon.status !== Image.Ready
        }

        Image {
            id: notifIcon
            Layout.minimumWidth: 28
            Layout.maximumWidth: 28
            Layout.minimumHeight: 28
            Layout.maximumHeight: 28
            fillMode: Image.PreserveAspectFit
            source: {
                if (root.notification && root.notification.image)
                    return root.notification.image;
                if (root.notification && root.notification.appIcon) {
                    return root.notification.appIcon.startsWith("/") ? "file://" + root.notification.appIcon : "image://icon/" + root.notification.appIcon;
                }
                return "";
            }
            sourceSize: Qt.size(28, 28)
            visible: status === Image.Ready
        }

        ColumnLayout {
            spacing: 3
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter

            Text {
                text: root.notification ? root.notification.summary : ""
                color: "#FFFFFF"
                font {
                    // family: Theme.fontFamily
                    pixelSize: 10
                    weight: 700
                }
                elide: Text.ElideRight
                Layout.fillWidth: true
                maximumLineCount: 1
            }

            Text {
                text: root.notification ? root.notification.body : ""
                color: "#9b9b9b"
                font {
                    // family: Theme.fontFamily
                    pixelSize: 9
                }
                elide: Text.ElideRight
                Layout.fillWidth: true
                maximumLineCount: 1
                visible: text !== ""
            }
        }
    }
}
