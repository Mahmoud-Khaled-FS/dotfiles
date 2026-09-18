import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Networking
import qs.services

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: root
            property string fontFamily: "JetBrainsMono Nerd Font"

            required property var modelData
            screen: modelData

            anchors.top: true
            anchors.left: true
            anchors.right: true
            implicitHeight: 30
            color: "#11111b"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                uniformCellSizes: true
                // Left Side
                RowLayout {
                    Repeater {
                        model: 5

                        Text {
                            id: ws
                            property var base: (Hyprland.monitorFor(root.screen).id * 5) + index
                            property var icons: ["1", "2", "3", "4", "5", "1", "2", "3", "4", "5"]
                            property bool isActive: Hyprland.workspaces.values.find(w => w.id == ws.base + 1)?.active ?? false
                            property bool isFocus: Hyprland.focusedWorkspace?.id === (ws.base + 1)
                            text: {
                                if (ws.base < 0 || ws.base >= icons.length) {
                                    return 0;
                                }
                                icons[ws.base];
                            }
                            color: isFocus ? "#89b4fa" : (isActive ? "#585b70" : "#45475a")

                            font {
                                pixelSize: 14
                                bold: true
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = "${index + 1}" })`)
                            }
                        }
                    }

                    Rectangle {
                        width: 1
                        height: 16
                        color: "#45475a"
                        anchors.margins: 5
                    }

                    Text {
                        id: window_title
                        text: Hyprland.activeToplevel?.wayland?.appId ?? ""
                        color: "#89dceb"
                        font {
                            pixelSize: 14
                            bold: true
                        }
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignCenter

                    Text {
                        id: clock
                        text: DateTime.time
                        color: "#89dceb"
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignRight

                    SysTray {}

                    Rectangle {
                        width: 1
                        height: 16
                        color: "#45475a"
                        anchors.margins: 5
                    }

                    Text {
                        id: networking
                        property var activeDevice: Networking.devices.values.find(n => n.connected)
                        property var type: networking.activeDevice.type
                        property string networkStatus: {
                            if (networking.type == 1) {
                                // WIFI
                                switch (networking.activeDevice) {
                                case 0:
                                    return "󰤫";
                                case 1:
                                case 3:
                                    // TODO: Handle wifi
                                    return "󰤨";
                                case 2:
                                case 4:
                                    return "󰤮";
                                }
                                return "";
                            } else if (networking.type == 2) {
                                // WIRED
                                switch (networking.activeDevice.state) {
                                case ConnectionState.Unknown:
                                    return "󰣻";
                                case ConnectionState.Connecting:
                                case ConnectionState.Connected:
                                    return "󰣺";
                                case ConnectionState.Disconnecting:
                                case ConnectionState.Disconnected:
                                    return "󰣼";
                                }
                            } else {
                                // NONE
                                return "󰣼";
                            }
                        }
                        text: `${networking.activeDevice.name}: ${networking.networkStatus}`
                        color: "#cba6f7"
                    }

                    Rectangle {
                        width: 1
                        height: 16
                        color: "#45475a"
                        anchors.margins: 5
                    }

                    Text {

                        text: {
                            let icon;
                            if (Info.volume > 50) {
                                icon = "";
                            } else if (Info.volume > 0) {
                                icon = "";
                            } else {
                                icon = "";
                            }
                            `${icon}  ${Info.volume}%`;
                        }
                        color: "#f5e0dc"
                        font {
                            pixelSize: 14
                            bold: true
                        }
                    }

                    Rectangle {
                        width: 1
                        height: 16
                        color: "#45475a"
                        anchors.margins: 5
                    }

                    Text {
                        text: `${Info.keyboardLayout}`
                        color: "#f5e0dc"
                        font {
                            pixelSize: 14
                            bold: true
                        }
                    }

                    Rectangle {
                        width: 1
                        height: 16
                        color: "#45475a"
                        anchors.margins: 5
                    }

                    Text {
                        text: `󰋊 ${Info.diskUsage}%`
                        color: "#cba6f7"
                        font {
                            pixelSize: 14
                            bold: true
                            family: root.fontFamily
                        }
                    }

                    Rectangle {
                        width: 1
                        height: 16
                        color: "#45475a"
                        anchors.margins: 5
                    }

                    Text {
                        text: ` ${Info.memUsage}%`
                        color: "#89b4fa"
                        font {
                            pixelSize: 14
                            bold: true
                            family: root.fontFamily
                        }
                    }

                    Rectangle {
                        width: 1
                        height: 16
                        color: "#45475a"
                        anchors.margins: 5
                    }

                    Text {
                        text: ` ${Info.cpuUsage}%`
                        color: "#f9e2af"
                        font {
                            pixelSize: 14
                            bold: true
                            family: root.fontFamily
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: Quickshell.execDetached(["sh", "-c", "kitty -e btop"])
                        }
                    }
                }
            }
        }
    }
}
