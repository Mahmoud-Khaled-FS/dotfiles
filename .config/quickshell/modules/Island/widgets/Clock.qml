import Quickshell
import QtQuick

Text {

    text: Qt.formatDateTime(clock.date, "hh:mm a")
    color: "#FFFFFF"

    font {
        // weight: 500
        bold: true
        pixelSize: 12
        letterSpacing: -0.5
    }
}
