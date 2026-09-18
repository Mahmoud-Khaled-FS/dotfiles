pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Singleton {
    id: clock
    property string time: Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clock.time = Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
    }
}