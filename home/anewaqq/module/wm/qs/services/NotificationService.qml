import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import "../core"

NotificationServer {
    id: notifServer
    keepOnReload: true

    onNotification: notif => {
        NotificationQueue.push(notif)
    }
}