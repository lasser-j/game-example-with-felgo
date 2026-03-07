import Felgo 4.0
import QtQuick 2.0

Item {
    z: 1 // forced object to be drawn above the game elements

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
            font.pixelSize: 40
            color: "red"
        }
        Text {
            id: secondaryText
            anchors.horizontalCenter:
                primaryText.text != "" ? primaryText.horizontalCenter : parent.horizontalCenter
            font.pixelSize: 14
            color: "red"
        }
    }
}
