import Felgo 4.0
import QtQuick 2.0

EntityBase {
    id: player
    entityType: "player"

    // player size
    width: spriteSequence.width
    height: spriteSequence.height

    // player image
    GameSpriteSequence {
      id: spriteSequence
      running: gameScene.gameRunning
      GameSprite {
        frameCount: 4
        frameRate: 1

        frameWidth: 39
        frameHeight: 39
        source: Qt.resolvedUrl("../../assets/img/player.png")
      }
    }

    // collider to check if enemy hits the player
    CircleCollider {
      radius: parent.height/2 // radius for collision detection
      anchors.centerIn: parent // position centered at player
      collisionTestingOnlyMode: true // player will not be affected by gravity or other applied physics forces

      // player should only collide with enemy
      categories:   Circle.Category1
      collidesWith: Circle.Category2

      // collision between player and enemy
      fixture.onBeginContact: (other) => {
        gameScene.gameOver()
      }
    }
}
