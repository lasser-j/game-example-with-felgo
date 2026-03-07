import Felgo 4.0
import QtQuick 2.0

EntityBase {
    id: enemy
    entityType: "enemy"

    // enemy size
    width: spriteSequence.width
    height: spriteSequence.height

    // direction and speed for enemy
    property real velocityX: 0
    property real velocityY: 0
    property real speed: 25

    // enemy image
    GameSpriteSequence {
      id: spriteSequence
      running: gameScene.gameRunning
      GameSprite {
        frameCount: 2
        frameRate: 5

        frameWidth: 39
        frameHeight: 39
        source: Qt.resolvedUrl("../../assets/img/enemy.png")
      }
    }

    // enemy movement towards player position
    MovementAnimation {
      id: movementX
      target: parent
      property: "x"
      velocity: velocityX * speed
      running: gameScene.gameRunning
    }

    MovementAnimation {
      id: movementY
      target: parent
      property: "y"
      velocity: velocityY * speed
      running: gameScene.gameRunning
    }

    // collider to check if enemy reached the player or was hit by a bullet
    CircleCollider {
        radius: parent.height/2 // radius for collision detection
        anchors.centerIn: parent // position centered at bullet
        collisionTestingOnlyMode: true // enemy will not be affected by gravity or other applied physics forces

        // enemy should collide with player and bullet
        categories:   Circle.Category2
        collidesWith: Circle.Category1 | Circle.Category3
    }
}
