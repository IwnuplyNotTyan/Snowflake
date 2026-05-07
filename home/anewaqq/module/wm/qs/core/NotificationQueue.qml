pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root

    property var queue: []
    property var current: null
    property bool showing: false

    signal showNotification(var notif)
    signal hideNotification

    function push(notif) {
        queue.push(notif)
        if (!current) next()
    }

    function next() {
        if (queue.length === 0) {
            current = null
            showing = false
            hideNotification()
            return
        }
        current = queue.shift()
        showing = true
        showNotification(current)
    }

    function dismiss() {
        if (current) current.expire()
        next()
    }
}