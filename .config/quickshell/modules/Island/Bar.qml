import Quickshell
import QtQuick
import qs.services
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Services.Notifications

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: root
            required property var modelData
            screen: modelData

            readonly property bool shouldTakeFocus: IslandManager.shouldFocus() && MonitorManager.isFocus(root.screen)

            WlrLayershell.keyboardFocus: root.shouldTakeFocus ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

            WlrLayershell.layer: WlrLayershell.Top

            // implicitHeight: 500
            property string fontFamily: "JetBrainsMono Nerd Font"

            anchors.top: true
            anchors.left: true
            anchors.right: true
            implicitHeight: 400
            exclusiveZone: 30
            color: "#00FFFFFF"

            SystemClock {
                id: clock
                precision: SystemClock.Seconds
            }

            mask: Region {
                Region {
                    intersection: Intersection.Combine
                    x: Math.floor(island.x)
                    y: Math.floor(island.y)
                    width: Math.ceil(island.width)
                    height: Math.ceil(island.height)
                }
            }

            DynamicIsland {
                id: island
                screen: root.screen
            }
        }
    }

    Connections {
        target: NotificationServer {
            id: notification_server

            bodySupported: true
            bodyImagesSupported: true
            actionsSupported: true
            persistenceSupported: true

            onNotification: n => {
                n.tracked = true;
                NotificationManager.enqueue(n);
            }
        }
    }
}

// Scope {

//     Variants {
//         model: Quickshell.screens

//         PanelWindow {
//             id: root
//             WlrLayershell.keyboardFocus: box.state === "app_launcher" || box.state === "power_menu"
//             IpcHandler {
//                 target: "appLauncher"
//                 function toggle(): void {
//                     box.state = box.state === "app_launcher" ? "island" : "app_launcher";
//                 }
//                 function show(): void {
//                     box.state = "app_launcher";
//                 }
//                 function hide(): void {
//                     box.state = "island";
//                 }
//             }

//             IpcHandler {
//                 target: "powerMenu"
//                 function toggle(): void {
//                     box.state = box.state === "power_menu" ? "island" : "power_menu";
//                 }
//                 function show(): void {
//                     box.state = "power_menu";
//                 }
//                 function hide(): void {
//                     box.state = "island";
//                 }
//             }

//             WlrLayershell.layer: WlrLayershell.Top
//             // implicitHeight: 500
//             property string fontFamily: "JetBrainsMono Nerd Font"

//             required property var modelData
//             screen: modelData

//             anchors.top: true
//             anchors.left: true
//             anchors.right: true
//             implicitHeight: 400
//             exclusiveZone: 30
//             color: "#00FFFFFF"

//             SystemClock {
//                 id: clock
//                 precision: SystemClock.Seconds
//             }

//             mask: Region {
//                 Region {
//                     intersection: Intersection.Combine
//                     x: Math.floor(box.x)
//                     y: Math.floor(box.y)
//                     width: Math.ceil(box.width)
//                     height: Math.ceil(box.height)
//                 }
//             }

//             Connections {
//                 target: NotificationServer {
//                     id: notification_server

//                     bodySupported: true
//                     bodyImagesSupported: true
//                     actionsSupported: true

//                     onNotification: n => {
//                         n.tracked = true;
//                         NotificationService.enqueue(n);
//                         box.state = "notification_bar";
//                     }
//                 }
//             }

//             Connections {
//                 target: NotificationService

//                 function onPopupFinished() {
//                     if (box.state === "notification_bar")
//                         box.state = "island";
//                 }
//             }

//             Rectangle {
//                 id: box
//                 property string state: "island"
//                 anchors.horizontalCenter: parent.horizontalCenter
//                 anchors.top: parent.top
//                 anchors.topMargin: 5
//                 clip: true

//                 onImplicitHeightChanged: {
//                     heightAnim.stop();
//                     heightAnim.to = implicitHeight;
//                     heightAnim.duration = 650;
//                     heightAnim.start();
//                 }
//                 Behavior on implicitWidth {
//                     NumberAnimation {
//                         duration: 225
//                         easing.type: Easing.OutExpo
//                     }
//                 }
//                 NumberAnimation {
//                     id: heightAnim
//                     target: box
//                     property: "height"
//                     easing.type: Easing.OutExpo
//                 }
//                 // width: 200
//                 implicitWidth: {
//                     switch (box.state) {
//                     case "island":
//                         return row.implicitWidth + 50;
//                     case "app_launcher":
//                         return 560;
//                     case "power_menu":
//                         return 470;
//                     case "notification_bar":
//                         return 300;
//                     }
//                 }
//                 color: "#11111b"
//                 // implicitWidth: 35
//                 implicitHeight: {
//                     switch (box.state) {
//                     case "island":
//                         return 30;
//                     case "app_launcher":
//                         return 300;
//                     case "power_menu":
//                         return 100;
//                     case "notification_bar":
//                         return 50;
//                     }
//                 }
//                 radius: 20
//                 RowLayout {
//                     id: row
//                     opacity: box.state === "island" ? 1 : 0
//                     visible: box.state === "island"
//                     anchors.centerIn: parent
//                     spacing: 13
//                     Volume {}
//                     Workspaces {}
//                     KeyboardLayout {}
//                     Clock {}
//                 }

//                 Item {
//                     anchors.centerIn: parent
//                     width: parent.width
//                     height: parent.height
//                     opacity: box.state === "app_launcher" ? 1 : 0
//                     visible: opacity > 0

//                     Behavior on opacity {
//                         SequentialAnimation {
//                             PauseAnimation {
//                                 duration: box.state === "app_launcher" ? 15 : 0
//                             }
//                             NumberAnimation {
//                                 duration: 150
//                                 easing.type: Easing.OutExpo
//                             }
//                         }
//                     }

//                     Loader {
//                         anchors.fill: parent
//                         active: box.state === "app_launcher"
//                         asynchronous: true

//                         sourceComponent: AppLauncher {
//                             shown: true
//                             onCloseRequested: box.state = "island"
//                         }

//                         onLoaded: {
//                             item.forceActiveFocus();
//                         }
//                     }
//                 }

//                 Item {
//                     anchors.centerIn: parent
//                     width: parent.width
//                     height: parent.height
//                     opacity: box.state === "power_menu" ? 1 : 0
//                     visible: opacity > 0

//                     Behavior on opacity {
//                         SequentialAnimation {
//                             PauseAnimation {
//                                 duration: box.state === "power_menu" ? 15 : 0
//                             }
//                             NumberAnimation {
//                                 duration: 150
//                                 easing.type: Easing.OutExpo
//                             }
//                         }
//                     }

//                     Loader {
//                         anchors.fill: parent
//                         active: box.state === "power_menu"
//                         asynchronous: true

//                         sourceComponent: PowerMenu {
//                             shown: true
//                             onCloseRequested: box.state = "island"
//                         }

//                         onLoaded: {
//                             item.forceActiveFocus();
//                         }
//                     }
//                 }

//                 NotificationBar {
//                     active: box.state === "notification_bar"
//                     notification: NotificationService.current
//                 }
//             }
//         }
//     }
// }
