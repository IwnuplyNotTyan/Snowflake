pragma Singleton
import QtQuick

QtObject {
    id: root

    property color background: "#0B0F10"
    property color surface: "#131718"
    property color foreground: "#c5c8c9"
    property color accent: "#96d6b0"
    property color secondary: "#7ba5dd"
    property color error: "#df5b61"
    property color warning: "#de8f78"
    property color success: "#87c7a1"

    property int fontSizeSmall: 18
    property int fontSizeMedium: 20
    property int fontSizeLarge: 22

    property int borderRadius: 10
    property int spacing: 10
}
