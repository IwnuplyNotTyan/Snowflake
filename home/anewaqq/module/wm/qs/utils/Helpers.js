pragma Singleton
import QtQuick

function clamp(value, min, max) {
    return Math.max(min, Math.min(max, value))
}

function formatBytes(bytes) {
    if (bytes < 1024) return bytes + " B"
    if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + " KB"
    if (bytes < 1024 * 1024 * 1024) return (bytes / (1024 * 1024)).toFixed(1) + " MB"
    return (bytes / (1024 * 1024 * 1024)).toFixed(1) + " GB"
}

function formatDuration(ms) {
    var seconds = Math.floor(ms / 1000)
    var minutes = Math.floor(seconds / 60)
    var hours = Math.floor(minutes / 60)
    
    if (hours > 0) {
        return hours + "h " + (minutes % 60) + "m"
    }
    if (minutes > 0) {
        return minutes + "m " + (seconds % 60) + "s"
    }
    return seconds + "s"
}