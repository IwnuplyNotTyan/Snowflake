pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool capsLock: false
    property bool numLock: false

    Process {
        id: lockProc
        command: ["bash", "-c", "xset q | grep -oP 'Caps Lock:\\s*\\K(on|off)'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.capsLock = this.text.trim() === "on"
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: lockProc.running = true
    }
}