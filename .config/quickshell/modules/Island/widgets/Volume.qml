import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    signal volumeChanged

    property string fg: "#FFFFFF"
    property string mutedFg: "#fb2a2a"
    property var sink: Pipewire.defaultAudioSink
    readonly property bool ready: sink && sink.ready
    readonly property bool muted: ready && sink.audio.muted
    readonly property int vol: ready ? Math.round(sink.audio.volume * 100) : 0

    onVolChanged: root.volumeChanged()
    onMutedChanged: root.volumeChanged()
    readonly property var sinkProps: ready ? sink.properties : ({})
    // onSinkPropsChanged: console.log("PW sink props:", JSON.stringify(sinkProps))

    property string activePort: ""
    readonly property bool isHeadphone: activePort.indexOf("headphone") !== -1 || activePort.indexOf("headset") !== -1

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    function checkPort() {
        if (!root.ready)
            return;
        portCheck.command = ["bash", "-c", "pactl list sinks | awk -v RS='' '/Name: " + root.sink.name + "/' | grep -oP 'Active Port: \\K.*'"];
        portCheck.running = true;
    }

    Process {
        id: portCheck
        stdout: SplitParser {
            onRead: data => root.activePort = data.trim()
        }
    }

    onSinkChanged: root.checkPort()

    MouseArea {
        id: audioMuted
        // Layout.
        anchors.fill: parent

        cursorShape: Qt.PointingHandCursor
        onClicked: root.sink.audio.muted = !root.sink.audio.muted
        hoverEnabled: true
    }

    RowLayout {
        id: content
        spacing: 4
        anchors.fill: parent

        // watch for jack plug/unplug events ral time
        Process {
            running: true
            command: ["pactl", "subscribe"]
            stdout: SplitParser {
                onRead: data => {
                    if (data.indexOf("on sink") !== -1)
                        root.checkPort();
                }
            }
        }

        Component.onCompleted: root.checkPort()

        property string icon: {
            if (!root.ready || root.muted)
                return root.isHeadphone ? "\uf025" : String.fromCodePoint(0xf0581);
            if (root.isHeadphone)
                return "\uee58";
            if (root.vol === 0)
                return String.fromCodePoint(0xf0581);
            if (root.vol < 40)
                return String.fromCodePoint(0xf0580);
            return String.fromCodePoint(0xf057e);
        }

        // icon
        Text {
            text: content.icon

            color: {
                if (root.muted || root.vol === 0) {
                    // console.log("audio volume status:", root.muted);
                    return root.mutedFg;
                }
                return root.fg;
            }

            // font.family: Theme.nerdFontFamily
            font.pixelSize: 10
        }

        // percentage
        Text {
            text: {
                if (!root.ready)
                    return "-";
                if (root.muted)
                    return "0%";
                return root.vol + "%";
            }
            color: root.fg

            font {
                pixelSize: 10
                // family: Theme.fontFamily
                weight: 500
            }
        }

        PwObjectTracker {
            objects: [root.sink]
        }
    }
}
