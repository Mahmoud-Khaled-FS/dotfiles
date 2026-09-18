import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services
import "../Bar"

FocusScope {
    id: root

    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property bool audioReady: sink && sink.ready && sink.audio
    readonly property bool muted: audioReady && sink.audio.muted
    readonly property int volume: audioReady ? Math.round(Math.max(0, Math.min(1, sink.audio.volume)) * 100) : 0

    clip: true

    function setVolume(position) {
        if (!audioReady || volumeTrack.width <= 0)
            return;

        sink.audio.volume = Math.max(0, Math.min(1, position / volumeTrack.width));
    }

    function notificationIcon(notification) {
        if (notification.image)
            return notification.image;
        if (notification.appIcon)
            return notification.appIcon.startsWith("/") ? "file://" + notification.appIcon : "image://icon/" + notification.appIcon;
        return "";
    }

    Keys.onEscapePressed: IslandManager.close()

    Component.onCompleted: root.forceActiveFocus()

    SystemClock {
        id: controlClock
        precision: SystemClock.Seconds
    }

    PwObjectTracker {
        objects: [root.sink]
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        ColumnLayout {
            Layout.preferredWidth: 592
            Layout.minimumWidth: 592
            Layout.maximumWidth: 592
            Layout.fillHeight: true
            spacing: 10

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                Layout.minimumHeight: 48
                Layout.maximumHeight: 48
                spacing: 14

                Text {
                    text: Qt.formatDateTime(controlClock.date, "hh:mm AP")
                    color: "#cdd6f4"
                    font.family: root.fontFamily
                    font.pixelSize: 29
                    font.weight: 700
                }

                Text {
                    Layout.alignment: Qt.AlignBottom
                    Layout.bottomMargin: 7

                    text: Qt.formatDateTime(controlClock.date, "dddd, dd MMMM")
                    color: "#a6adc8"
                    font.family: root.fontFamily
                    font.pixelSize: 11
                    font.weight: 500
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    text: "CONTROL CENTER"
                    color: "#6c7086"
                    font.family: root.fontFamily
                    font.pixelSize: 9
                    font.letterSpacing: 1.5
                    font.weight: 700
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 74
                Layout.minimumHeight: 74
                Layout.maximumHeight: 74
                spacing: 10

            ConnectivityTile {
                Layout.preferredWidth: 145
                Layout.fillHeight: true

                icon: "󰖩"
                label: "Wi-Fi"
                accent: "#89b4fa"
            }

            ConnectivityTile {
                Layout.preferredWidth: 145
                Layout.fillHeight: true

                icon: "󰂯"
                label: "Bluetooth"
                accent: "#cba6f7"
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true

                radius: 14
                color: "#181825"
                border.width: 1
                border.color: root.audioReady ? "#45475a" : "#313244"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 11
                    spacing: 8

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Sound"
                            color: "#cdd6f4"
                            font.family: root.fontFamily
                            font.pixelSize: 11
                            font.weight: 600
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Text {
                            text: root.audioReady ? root.volume + "%" : "Unavailable"
                            color: root.audioReady ? "#f5e0dc" : "#6c7086"
                            font.family: root.fontFamily
                            font.pixelSize: 11
                            font.weight: 700
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 9

                        Text {
                            text: root.muted || root.volume === 0 ? "󰝟" : "󰕾"
                            color: root.muted ? "#f38ba8" : "#f5e0dc"
                            font.family: root.fontFamily
                            font.pixelSize: 16

                            MouseArea {
                                anchors.fill: parent
                                anchors.margins: -5
                                enabled: root.audioReady
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.sink.audio.muted = !root.sink.audio.muted
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 18

                            Rectangle {
                                id: volumeTrack

                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                height: 5
                                radius: height / 2
                                color: "#313244"

                                Rectangle {
                                    width: parent.width * root.volume / 100
                                    height: parent.height
                                    radius: parent.radius
                                    color: root.muted ? "#6c7086" : "#f5e0dc"
                                }

                                Rectangle {
                                    x: Math.max(0, Math.min(parent.width - width, parent.width * root.volume / 100 - width / 2))
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: 11
                                    height: 11
                                    radius: width / 2
                                    color: root.audioReady ? "#cdd6f4" : "#585b70"
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                enabled: root.audioReady
                                cursorShape: Qt.PointingHandCursor

                                onPressed: mouse => root.setVolume(mouse.x)
                                onPositionChanged: mouse => {
                                    if (pressed)
                                        root.setVolume(mouse.x);
                                }
                            }
                        }
                    }
                }
            }
        }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true

            radius: 16
            color: "#181825"
            border.width: 1
            border.color: "#45475a"

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 9

                MetricCard {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    icon: ""
                    label: "CPU"
                    value: Info.cpuUsage
                    detail: "Processor usage"
                    accent: "#f9e2af"
                }

                MetricCard {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    icon: ""
                    label: "RAM"
                    value: Info.memUsage
                    detail: "Memory usage"
                    accent: "#89b4fa"
                }

                MetricCard {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    icon: "󰢮"
                    label: "GPU"
                    value: 0
                    detail: "Backend unavailable"
                    accent: "#a6e3a1"
                    available: false
                }

                MetricCard {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    icon: "󰋊"
                    label: "DISK"
                    value: Info.diskUsage
                    detail: "Root filesystem"
                    accent: "#cba6f7"
                }
                }
            }
        }

        Rectangle {
            Layout.preferredWidth: 300
            Layout.minimumWidth: 300
            Layout.maximumWidth: 300
            Layout.fillHeight: true

            radius: 16
            color: "#181825"
            border.width: 1
            border.color: "#45475a"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 8

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 32
                    spacing: 8

                    Rectangle {
                        Layout.preferredWidth: 32
                        Layout.preferredHeight: 32

                        radius: 10
                        color: Qt.rgba(0.953, 0.545, 0.659, 0.13)

                        Text {
                            anchors.centerIn: parent
                            text: "󰂚"
                            color: "#f38ba8"
                            font.family: root.fontFamily
                            font.pixelSize: 15
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 1

                        Text {
                            text: "Notifications"
                            color: "#cdd6f4"
                            font.family: root.fontFamily
                            font.pixelSize: 12
                            font.weight: 700
                        }

                        Text {
                            text: NotificationManager.notifications.length === 1
                                ? "1 recent alert"
                                : NotificationManager.notifications.length + " recent alerts"
                            color: "#6c7086"
                            font.family: root.fontFamily
                            font.pixelSize: 8
                        }
                    }

                    Rectangle {
                        id: clearButton

                        Layout.preferredWidth: 54
                        Layout.preferredHeight: 26

                        readonly property bool available: NotificationManager.notifications.length > 0

                        radius: 8
                        color: clearMouse.containsMouse && available ? "#313244" : "#11111b"
                        opacity: available ? 1 : 0.45

                        Text {
                            anchors.centerIn: parent
                            text: "Clear"
                            color: "#a6adc8"
                            font.family: root.fontFamily
                            font.pixelSize: 8
                            font.weight: 600
                        }

                        MouseArea {
                            id: clearMouse

                            anchors.fill: parent
                            enabled: clearButton.available
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: NotificationManager.clearAll()
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ListView {
                        id: notificationList

                        anchors.fill: parent
                        clip: true
                        model: NotificationManager.notifications
                        spacing: 6
                        boundsBehavior: Flickable.StopAtBounds

                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AsNeeded
                        }

                        delegate: Rectangle {
                            id: notificationCard

                            required property var modelData

                            width: notificationList.width
                            height: modelData.body ? 82 : 66
                            radius: 11
                            color: cardMouse.containsMouse ? "#1e1e2e" : "#11111b"
                            border.width: 1
                            border.color: cardMouse.containsMouse ? "#45475a" : "#313244"

                            Behavior on color {
                                ColorAnimation {
                                    duration: 100
                                }
                            }

                            MouseArea {
                                id: cardMouse

                                anchors.fill: parent
                                acceptedButtons: Qt.NoButton
                                hoverEnabled: true
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 9
                                spacing: 9

                                Rectangle {
                                    Layout.preferredWidth: 34
                                    Layout.preferredHeight: 34
                                    Layout.alignment: Qt.AlignTop

                                    radius: 10
                                    color: "#181825"

                                    Image {
                                        id: notificationImage

                                        anchors.centerIn: parent
                                        width: 24
                                        height: 24
                                        fillMode: Image.PreserveAspectFit
                                        source: root.notificationIcon(notificationCard.modelData)
                                        sourceSize: Qt.size(24, 24)
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        visible: notificationImage.status !== Image.Ready
                                        text: "󰂚"
                                        color: "#f38ba8"
                                        font.family: root.fontFamily
                                        font.pixelSize: 14
                                    }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    spacing: 2

                                    Text {
                                        Layout.fillWidth: true

                                        text: notificationCard.modelData.appName || "Notification"
                                        color: "#6c7086"
                                        elide: Text.ElideRight
                                        textFormat: Text.PlainText
                                        font.family: root.fontFamily
                                        font.pixelSize: 8
                                        font.weight: 600
                                    }

                                    Text {
                                        Layout.fillWidth: true

                                        text: notificationCard.modelData.summary
                                        color: "#cdd6f4"
                                        elide: Text.ElideRight
                                        textFormat: Text.PlainText
                                        font.family: root.fontFamily
                                        font.pixelSize: 10
                                        font.weight: 700
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        visible: text !== ""
                                        text: notificationCard.modelData.body
                                        color: "#a6adc8"
                                        elide: Text.ElideRight
                                        maximumLineCount: 2
                                        wrapMode: Text.Wrap
                                        textFormat: Text.PlainText
                                        font.family: root.fontFamily
                                        font.pixelSize: 8
                                    }
                                }

                                Rectangle {
                                    id: dismissButton

                                    Layout.preferredWidth: 24
                                    Layout.preferredHeight: 24
                                    Layout.alignment: Qt.AlignTop

                                    radius: 8
                                    color: dismissMouse.containsMouse ? "#45475a" : "transparent"

                                    Text {
                                        anchors.centerIn: parent
                                        text: "󰅖"
                                        color: dismissMouse.containsMouse ? "#f38ba8" : "#6c7086"
                                        font.family: root.fontFamily
                                        font.pixelSize: 11
                                    }

                                    MouseArea {
                                        id: dismissMouse

                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: NotificationManager.dismiss(notificationCard.modelData)
                                    }
                                }
                            }
                        }
                    }

                    Column {
                        anchors.centerIn: parent
                        spacing: 7
                        visible: notificationList.count === 0

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "󰂛"
                            color: "#45475a"
                            font.family: root.fontFamily
                            font.pixelSize: 28
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "All caught up"
                            color: "#a6adc8"
                            font.family: root.fontFamily
                            font.pixelSize: 10
                            font.weight: 600
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "New notifications will appear here"
                            color: "#6c7086"
                            font.family: root.fontFamily
                            font.pixelSize: 8
                        }
                    }
                }
            }
        }
    }

    component ConnectivityTile: Rectangle {
        id: tile

        required property string icon
        required property string label
        required property color accent

        radius: 14
        color: "#181825"
        border.width: 1
        border.color: "#313244"

        RowLayout {
            anchors.fill: parent
            anchors.margins: 11
            spacing: 10

            Rectangle {
                Layout.preferredWidth: 38
                Layout.preferredHeight: 38

                radius: 12
                color: Qt.rgba(tile.accent.r, tile.accent.g, tile.accent.b, 0.12)

                Text {
                    anchors.centerIn: parent
                    text: tile.icon
                    color: tile.accent
                    font.family: root.fontFamily
                    font.pixelSize: 18
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 3

                Text {
                    text: tile.label
                    color: "#cdd6f4"
                    font.family: root.fontFamily
                    font.pixelSize: 11
                    font.weight: 600
                }

                Text {
                    text: "Unavailable"
                    color: "#6c7086"
                    font.family: root.fontFamily
                    font.pixelSize: 8
                }
            }
        }
    }

    component MetricCard: Rectangle {
        id: card

        required property string icon
        required property string label
        required property string detail
        required property color accent
        required property int value
        property bool available: true

        radius: 12
        color: "#11111b"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 6

            RowLayout {
                Layout.fillWidth: true

                Rectangle {
                    Layout.preferredWidth: 30
                    Layout.preferredHeight: 30

                    radius: 9
                    color: Qt.rgba(card.accent.r, card.accent.g, card.accent.b, 0.14)

                    Text {
                        anchors.centerIn: parent
                        text: card.icon
                        color: card.available ? card.accent : "#6c7086"
                        font.family: root.fontFamily
                        font.pixelSize: 15
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    text: card.label
                    color: "#a6adc8"
                    font.family: root.fontFamily
                    font.pixelSize: 9
                    font.letterSpacing: 0.8
                    font.weight: 700
                }
            }

            Text {
                text: card.available ? card.value + "%" : "--"
                color: card.available ? "#cdd6f4" : "#6c7086"
                font.family: root.fontFamily
                font.pixelSize: 24
                font.weight: 700
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 4

                radius: height / 2
                color: "#313244"

                Rectangle {
                    width: card.available ? parent.width * Math.max(0, Math.min(100, card.value)) / 100 : 0
                    height: parent.height
                    radius: parent.radius
                    color: card.accent

                    Behavior on width {
                        NumberAnimation {
                            duration: 300
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }

            Text {
                Layout.fillWidth: true

                text: card.detail
                color: "#6c7086"
                elide: Text.ElideRight
                font.family: root.fontFamily
                font.pixelSize: 8
            }
        }
    }
}
