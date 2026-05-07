import QtQuick
import Quickshell
import Quickshell.Io

FloatingWindow {
    id: root
    visible: false
    width: 400
    height: 140

    property int volume: 0
    property string sinkName: "Speakers"
    property string currentTime: "00:00"

    screen: Quickshell.focusedScreen

    onScreenChanged: {
        if (screen) {
            x = screen.x + screen.width - width - 40
            y = screen.y + screen.height - height - 40
        }
    }

    Process {
        id: volumeProc
        command: ["bash", "-c", "pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\\d+(?=%)' | head -1"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                root.volume = parseInt(this.text.trim()) || 0
            }
        }
    }

    Process {
        id: sinkProc
        command: ["bash", "-c", "pactl get-default-sink | sed 's/^.*\\.//' | sed 's/_/ /g'"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                root.sinkName = this.text.trim() || "Speakers"
            }
        }
    }

    Process {
        id: timeProc
        command: ["date", "+%H:%M"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.currentTime = this.text.trim()
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: timeProc.running = true
    }

    function show() {
        volumeProc.running = true
        sinkProc.running = true
        root.visible = true
        hideTimer.restart()
    }

    Timer {
        id: hideTimer
        interval: 2000
        onTriggered: root.visible = false
    }

    Rectangle {
        anchors.fill: parent
        color: "#0B0F10"
        radius: 4

Column {
            anchors.fill: parent
            anchors.topMargin: 10
            anchors.bottomMargin: 8
            spacing: 4

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10

                Text {
                    text: {
                        if (volume === 0) return " "
                        if (volume <= 33) return " "
                        if (volume <= 66) return " "
                        return " "
		    }
		    color: "#cccccc"
                    font.pixelSize: 14
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    width: 120
                    height: 6
                    radius: 3
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#cccccc"

                    Rectangle {
                        width: parent.width * (root.volume / 100)
                        height: parent.height
                        radius: parent.radius
                        color: "#cccccc"
                    }
                }

                Text {
                    text: root.currentTime
                    color: "#cccccc"
                    font.pixelSize: 10
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Text {
                text: root.sinkName
                color: "#cccccc"
                font.pixelSize: 11
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
