import Felgo 4.0
import QtQuick 2.0

import "entities"

Scene {
    id: gameScene

    // background image
    Image {
        anchors.fill: gameWindowAnchorItem
        fillMode: Image.PreserveAspectCrop
        source: "../assets/img/background.png"
    }

    // player
    Player {
        anchors.horizontalCenter: gameWindowAnchorItem.horizontalCenter
        y: gameWindowAnchorItem.height - height - 10
    }
}
