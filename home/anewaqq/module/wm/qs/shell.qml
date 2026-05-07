import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import "./core"
import "./services"
import "./modules"

ShellRoot {
    NotificationService { id: notifService }

    NotificationPopup {
        id: notifPopup
    }

    OsdVolume {
        id: osdVolume
    }

    IpcHandler {
        target: "shell"
        function reload(): void { Quickshell.reload() }
    }

    IpcHandler {
        target: "osd"
        function showVolume(): void { osdVolume.show() }
    }
}
