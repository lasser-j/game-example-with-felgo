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
        id: player
        anchors.horizontalCenter: gameWindowAnchorItem.horizontalCenter
        y: gameWindowAnchorItem.height - height - 10
    }

    // create bullets at runtime
    EntityManager {
      id: entityManager
      entityContainer: gameScene
    }

    // trigger bullet shots when mouse was clicked
    MouseArea {
        anchors.fill: gameWindowAnchorItem
        onClicked: (mouse)=> {
            // calculate direction for the bullet (direction from player to mouse location)
            var dx = mouse.x - (player.x + player.width/2)
            var dy = mouse.y - (player.y + player.height/2)
            var len = Math.sqrt(dx*dx + dy*dy)
            dx /= len
            dy /= len

            // set propeerties for bullet
            // x/y: start position of bullet - player position moved slightly into direction of mouse click
            // velocityX/Y: direction towards mouse position, used for moving the bullet
            var newEntityProperties = {
                x: player.x + player.width/2 - 7 + 20*dx,
                y: player.y + player.height/2 - 7 + 20*dy,
                velocityX: dx,
                velocityY: dy
            }

            entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("entities/Bullet.qml"), newEntityProperties);
        }
    }
}
