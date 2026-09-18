import QtQuick
import QtQuick.Layouts

FocusScope {
    id: root

    required property string message
    property int currentIndex: 1

    signal accepted
    signal rejected

    clip: true

    function choose(index) {
        currentIndex = index;

        if (index === 0) {
            accepted();
        } else {
            rejected();
        }
    }

    Keys.onLeftPressed: currentIndex = 0
    Keys.onRightPressed: currentIndex = 1
    Keys.onReturnPressed: choose(currentIndex)
    Keys.onEnterPressed: choose(currentIndex)
    Keys.onEscapePressed: rejected()

    Component.onCompleted: root.forceActiveFocus()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        Text {
            Layout.fillWidth: true

            text: root.message
            color: "#cdd6f4"
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 13
            font.weight: 600
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            ChoiceButton {
                Layout.fillWidth: true
                Layout.fillHeight: true

                label: "Yes"
                selected: root.currentIndex === 0
                accent: "#f38ba8"
                index: 0
            }

            ChoiceButton {
                Layout.fillWidth: true
                Layout.fillHeight: true

                label: "No"
                selected: root.currentIndex === 1
                accent: "#89b4fa"
                index: 1
            }
        }
    }

    component ChoiceButton: Rectangle {
        id: button

        required property string label
        required property bool selected
        required property color accent
        required property int index

        radius: 14
        color: selected || mouseArea.containsMouse ? "#181825" : "#1e1e2e"
        border.width: 1
        border.color: selected ? accent : "#45475a"
        scale: mouseArea.pressed ? 0.97 : 1

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
                duration: 100
                easing.type: Easing.OutCubic
            }
        }

        Text {
            anchors.centerIn: parent

            text: button.label
            color: button.selected ? button.accent : "#a6adc8"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 12
            font.weight: 700
        }

        MouseArea {
            id: mouseArea

            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onEntered: root.currentIndex = button.index
            onClicked: root.choose(button.index)
        }
    }
}
