import Felgo 4.0
import QtQuick 2.0

EntityBase {
    id: bullet
    entityType: "bullet"

    // bullet size
    width: spriteSequence.width
    height: spriteSequence.height

    // direction and speed for bullet
    property real velocityX: 0
    property real velocityY: 0
    property real speed: 50

    // bullet image
    GameSpriteSequence {
      id: spriteSequence
      running: gameScene.gameRunning
      GameSprite {
        frameCount: 4
        frameRate: 15

        frameWidth: 10
        frameHeight: 10
        source: Qt.resolvedUrl("../../assets/img/bullet.png")
      }
    }

    // bullet movement from player position towards mouse position
    MovementAnimation {
      id: movementX
      target: parent
      property: "x"
      velocity: velocityX * speed
      minPropertyValue: -parent.width
      maxPropertyValue: gameScene.gameWindowAnchorItem.width
      running: gameScene.gameRunning

      onLimitReached: {
          removeEntity()
      }
    }

    MovementAnimation {
      id: movementY
      target: parent
      property: "y"
      velocity: velocityY * speed
      minPropertyValue: -parent.height
      maxPropertyValue: gameScene.gameWindowAnchorItem.height
      running: gameScene.gameRunning

      onLimitReached: {
          removeEntity()
      }
    }

    // collider to check if bullet hits an enemy
    CircleCollider {
      radius: parent.height/2 // radius for collision detection
      anchors.centerIn: parent // position centered at bullet
      collisionTestingOnlyMode: true // bullet will not be affected by gravity or other applied physics forces

      // bullet should only collide with enemy
      categories:   Circle.Category3
      collidesWith: Circle.Category2

      // collision between bullet and enemy
      fixture.onBeginContact: (other) => {
          // increase score
          gameScene.score++
          // remove hit enemy and shot bullet
          other.getBody().target.removeEntity()
          removeEntity()
      }
    }
}
