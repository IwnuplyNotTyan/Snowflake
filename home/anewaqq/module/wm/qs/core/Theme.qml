pragma Singleton
import QtQuick

QtObject {
    id: root

    property color background: "#1e1e2e"
    property color surface: "#313244"
    property color foreground: "#cdd6f4"
    property color accent: "#cba6f7"
    property color secondary: "#a6adc8"
    property color error: "#f38ba8"
    property color warning: "#fab387"
    property color success: "#a6e3a1"

    property int fontSizeSmall: 12
    property int fontSizeMedium: 14
    property int fontSizeLarge: 18

    property int borderRadius: 10
    property int spacing: 10
}