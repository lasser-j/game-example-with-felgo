import Felgo 4.0
import QtQuick 2.0

Item {
    anchors.centerIn: gameWindowAnchorItem
    visible: !gameRunning
    z: 1

    property alias primaryText: primaryText.text
    property alias secondaryText: secondaryText.text

    // background
    Rectangle {
        anchors.fill: textBlock
        color: "darkgray"
        opacity: 0.2
    }

    // overlay text
    Column {
        id: textBlock
        anchors.centerIn: parent
        Text {
            id: primaryText
            text: "pause"
            font.pixelSize: 40
            color: "red"
        }
        Text {
            id: secondaryText
            text: "click to start"
            anchors.horizontalCenter: primaryText.horizontalCenter
            font.pixelSize: 14
            color: "red"
        }
    }
}
