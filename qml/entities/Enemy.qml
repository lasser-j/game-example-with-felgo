import Felgo 4.0
import QtQuick 2.0

EntityBase {

    id: enemy
    entityType: "enemy"

    // enemy size
    width: 40
    height: 40

    // direction and speed for enemy
    property real velocityX: 0
    property real velocityY: 0
    property real speed: 25

    // enemy image
    Image {
        anchors.fill: parent
        source: "../../assets/img/enemy.png"
        fillMode: Image.PreserveAspectFit
    }

    // enemy movement towards player position
    MovementAnimation {
      id: movementX
      target: parent
      property: "x"
      velocity: velocityX * speed
      running: true
    }

    MovementAnimation {
      id: movementY
      target: parent
      property: "y"
      velocity: velocityY * speed
      running: true
    }

    CircleCollider {
      radius: parent.height/2
      anchors.centerIn: parent

      bodyType: Body.Dynamic
    }

}
