pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property var lastCpuTotal: 0
    property var lastCpuIdle: 0
    property int cpuUsage: 0
    property var memUsage: 0
    property var diskUsage: 0

    property var keyboardLayout: "En"

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    property int volume: {
            const audio = Pipewire.defaultAudioSink.audio;
            if (!audio || audio.muted) {
                0
            }else {
                Math.round(audio.volume * 100)
            }
        }



    Process {
        id: cpuProc
        command: ["sh", "-c", "head -1 /proc/stat"]

        stdout: SplitParser {
            onRead: data => {
                // Parse /proc/stat
                const p = data.trim().split(/\s+/);
                const idle = parseInt(p[4]) + parseInt(p[5]);
                const total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0);
                if (root.lastCpuTotal > 0) {
                    root.cpuUsage = Math.round(100 * (1 - (idle - root.lastCpuIdle) / (total - root.lastCpuTotal)));
                }
                root.lastCpuTotal = total;
                root.lastCpuIdle = idle;
            }
        }

        Component.onCompleted: running = true
    }

    Process {
        id: memProc
        command: ['sh', '-c', "free -b | awk '/^Mem:/ {print $2, $3}'"]
        stdout: SplitParser {
            onRead: data => {
                const [total, used] = data.trim().split(/\s+/).map(Number);

                root.memUsage = total > 0 ? Math.round((used / total) * 100) : 0;
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: diskProc
        command: ["sh", "-c", "df -B1 / | awk 'NR==2 {print $5}'"]
        stdout: SplitParser {
            onRead: data => root.diskUsage = parseInt(data.trim(), 10) || 0
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = true;
            memProc.running = true;
            diskProc.running = true;
        }
    }

    Process {
        id: keyboard
        command: ["sh", "-c", "hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap'"]

        stdout: SplitParser {
            onRead: data => {
                root.keyboardLayout = data.trim().toLowerCase() === "arabic" ? "Ar" : "En";
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
                    root.keyboardLayout = "UNKNOWN";
                    return;
                }
                root.keyboardLayout = parts[1].trim().toLowerCase() === "arabic" ? "Ar" : "En";
            }
        }
    }
}
