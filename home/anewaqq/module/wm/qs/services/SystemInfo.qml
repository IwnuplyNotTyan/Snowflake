pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real cpuUsage: 0
    property real memUsage: 0
    property int batteryPercent: 100
    property bool batteryCharging: false
    property int brightness: 100

    Process {
        id: cpuProc
        command: ["bash", "-c", "grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$3+$4+$5)} END {print usage}'"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: root.cpuUsage = parseFloat(this.text) || 0
        }
    }

    Process {
        id: memProc
        command: ["bash", "-c", "awk '/MemAvailable/ {printf \"%.0f\", $3*100/$2}' /proc/meminfo"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: root.memUsage = parseFloat(this.text) || 0
        }
    }

    Process {
        id: batteryProc
        command: ["bash", "-c", "cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 100"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: root.batteryPercent = parseInt(this.text) || 100
        }
    }

    Process {
        id: brightProc
        command: ["bash", "-c", "cat /sys/class/backlight/intel_backlight/brightness 2>/dev/null || echo 100"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: root.brightness = parseInt(this.text) || 100
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = true
            memProc.running = true
            batteryProc.running = true
        }
    }
}