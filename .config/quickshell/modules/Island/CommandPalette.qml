import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.services

FocusScope {
    id: root

    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    property int selectedIndex: 0
    property string searchQuery: ""
    property var filteredCommands: CommandManager.commands(searchQuery)

    clip: true

    onFilteredCommandsChanged: selectedIndex = 0

    Component.onCompleted: {
        searchQuery = "";
        searchInput.text = "";
        selectedIndex = 0;
        searchInput.forceActiveFocus();
    }

    function runSelected() {
        filteredCommands[selectedIndex].run();
        IslandManager.close();
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 34
            Layout.minimumHeight: 34
            Layout.maximumHeight: 34
            spacing: 10

            Rectangle {
                Layout.preferredWidth: 34
                Layout.preferredHeight: 34

                radius: 10
                color: Qt.rgba(0.537, 0.706, 0.98, 0.14)

                Text {
                    anchors.centerIn: parent
                    text: "󰀻"
                    color: "#89b4fa"
                    font.family: root.fontFamily
                    font.pixelSize: 17
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 1

                Text {
                    text: "Commands"
                    color: "#cdd6f4"
                    font.family: root.fontFamily
                    font.pixelSize: 13
                    font.weight: 700
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            Layout.minimumHeight: 30
            Layout.maximumHeight: 30

            radius: 5
            color: "#181825"
            border.width: 1
            border.color: searchInput.activeFocus ? "#89b4fa" : "#313244"

            Behavior on border.color {
                ColorAnimation {
                    duration: 120
                }
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 9

                Text {
                    text: ">"
                    color: searchInput.activeFocus ? "#89b4fa" : "#6c7086"
                    font.family: root.fontFamily
                    font.pixelSize: 15
                }

                TextInput {
                    id: searchInput

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    verticalAlignment: TextInput.AlignVCenter
                    color: "#cdd6f4"
                    selectionColor: "#45475a"
                    selectedTextColor: "#cdd6f4"
                    font.family: root.fontFamily
                    font.pixelSize: 11
                    clip: true

                    onTextChanged: root.searchQuery = text

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Search commands..."
                        color: "#6c7086"
                        font: searchInput.font
                        visible: searchInput.text.length === 0
                    }

                    Keys.onPressed: event => {
                        if (event.key === Qt.Key_Down) {
                            if (root.filteredCommands.length > 0) {
                                root.selectedIndex = (root.selectedIndex + 1) % root.filteredCommands.length;
                                commandList.positionViewAtIndex(root.selectedIndex, ListView.Contain);
                            }
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Up) {
                            if (root.filteredCommands.length > 0) {
                                root.selectedIndex = root.selectedIndex <= 0 ? root.filteredCommands.length - 1 : root.selectedIndex - 1;
                                commandList.positionViewAtIndex(root.selectedIndex, ListView.Contain);
                            }
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            root.runSelected();
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Escape) {
                            IslandManager.close();
                            event.accepted = true;
                        }
                    }
                }

                Text {
                    text: root.filteredCommands.length === 0 ? "--" : root.selectedIndex + 1 + " / " + root.filteredCommands.length
                    color: "#a6adc8"
                    font.family: root.fontFamily
                    font.pixelSize: 9
                    font.weight: 600
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true

            radius: 5
            color: "#181825"
            border.width: 1
            border.color: "#45475a"

            ListView {
                id: commandList

                anchors.fill: parent
                anchors.margins: 6
                clip: true
                model: root.filteredCommands
                currentIndex: root.selectedIndex
                highlightFollowsCurrentItem: false
                spacing: 3

                delegate: Rectangle {
                    id: rowDelegate

                    required property int index
                    required property var modelData

                    width: commandList.width
                    height: 30
                    radius: 5
                    color: index === root.selectedIndex ? "#11111b" : (rowMouse.containsMouse ? "#1e1e2e" : "transparent")
                    border.width: 1
                    border.color: index === root.selectedIndex ? "#585b70" : "transparent"

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

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 10
                        spacing: 10

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            spacing: 2

                            Text {
                                Layout.fillWidth: true

                                text: rowDelegate.modelData.name
                                color: "#cdd6f4"
                                elide: Text.ElideRight
                                font.family: root.fontFamily
                                font.pixelSize: 10
                                font.weight: index === root.selectedIndex ? 700 : 600
                            }
                        }

                        Text {
                            text: "󰁔"
                            color: index === root.selectedIndex ? "#89b4fa" : "#45475a"
                            font.family: root.fontFamily
                            font.pixelSize: 14
                        }
                    }

                    MouseArea {
                        id: rowMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onEntered: root.selectedIndex = rowDelegate.index
                        onClicked: root.launchSelected()
                    }
                }

                Column {
                    anchors.centerIn: parent
                    spacing: 6
                    visible: commandList.count === 0

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "󰅖"
                        color: "#585b70"
                        font.family: root.fontFamily
                        font.pixelSize: 22
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "There is No Commands"
                        color: "#6c7086"
                        font.family: root.fontFamily
                        font.pixelSize: 9
                        font.weight: 600
                    }
                }
            }
        }
    }
}
