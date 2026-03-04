import Felgo 4.0
import QtQuick 2.0

EntityBase {
    id: player
    entityType: "player"

    // player size
    width: 40
    height: 40

    // player image
    Image {
        anchors.fill: parent
        source: "../../assets/img/player.png"
        fillMode: Image.PreserveAspectFit
    }

    // collider to check if enemy hits the player
    CircleCollider {
      radius: parent.height/2 // radius for collision dedection
      anchors.centerIn: parent // position centered at player
      collisionTestingOnlyMode: true // player will not be affected by gravity or other applied physics forces

      // player should only collide with enemy
      categories:   Circle.Category1
      collidesWith: Circle.Category2

      // collisision between player and enemy
      fixture.onBeginContact: (other) => {
        gameScene.gameOver();
      }
    }
}
