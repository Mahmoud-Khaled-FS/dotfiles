import Quickshell
import QtQuick
import Quickshell.Hyprland
import Quickshell.Io

Text {

    property string kbl: ""
    text: kbl
    color: "#FFFFFF"

    font {
        weight: 500
        pixelSize: 10
        letterSpacing: -0.5
    }

    Process {
        id: keyboard
        command: ["sh", "-c", "hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap'"]

        stdout: SplitParser {
            onRead: data => {
                kbl = data.trim().toLowerCase() === "arabic" ? "Ar" : "En";
            }
        }

        Component.onCompleted: running = true
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "activelayout") {
                const parts = event.data.split(',');
                if (parts.length < 2) {
                    kbl = "UNKNOWN";
                    return;
                }
                kbl = parts[1].trim().toLowerCase() === "arabic" ? "Ar" : "En";
            }
        }
    }
}
