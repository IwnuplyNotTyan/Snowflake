import QtQuick
import Quickshell
import "../core"

FloatingWindow {
    id: root
    visible: false
    width: 320
    height: 80
    screen: Quickshell.focusedScreen

    property string appName: ""
    property string summary: ""
    property string body: ""
    property string urgency: "normal"
    property var actions: []
    property var notif

    onScreenChanged: {
        if (screen) {
            x = screen.x + 20
            y = screen.y + screen.height - height - 20
        }
    }

    Connections {
        target: NotificationQueue

        function onShowNotification(notif) {
            root.notif = notif
            root.appName = notif.appName || ""
            root.summary = notif.summary || ""
            root.body = notif.body || ""
            root.urgency = notif.urgency || "normal"
            root.actions = notif.actions || []
            root.visible = true
            hideTimer.restart()
        }

        function onHideNotification() {
            root.visible = false
        }
    }

    Timer {
        id: hideTimer
        interval: 5000
        onTriggered: NotificationQueue.dismiss()
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.background
        radius: Theme.borderRadius

        Row {
            anchors.fill: parent
            anchors.margins: Theme.spacing
            spacing: Theme.spacing

            Rectangle {
                width: 4
                height: parent.height
                radius: 2
                color: {
                    switch (root.urgency) {
                        case "critical": return Theme.error
                        case "low": return Theme.secondary
                        default: return Theme.accent
                    }
                }
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4

                Text {
                    text: root.summary
                    color: Theme.foreground
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: true
                }

                Text {
                    text: root.body
                    color: Theme.secondary
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                    maximumLineCount: 2
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: NotificationQueue.dismiss()
        }
    }
}