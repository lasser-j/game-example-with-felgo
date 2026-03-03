import Felgo 4.0
import QtQuick 2.0

Scene {
    id: gameScene

    Image {
        anchors.fill: gameWindowAnchorItem
        fillMode: Image.PreserveAspectCrop
        source: "../assets/img/background.png"
    }
}
