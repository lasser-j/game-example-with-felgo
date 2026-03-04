import Felgo 4.0
import QtQuick 2.0

EntityBase {

    id: bullet
    entityType: "bullet"

    // bullet size
    width: 10
    height: 10

    // speed and direction for bullet
    property real velocityX: 0
    property real velocityY: 0
    property real speed: 50

    // bullet image
    Image {
        anchors.fill: parent
        source: "../../assets/img/bullet.png"
        fillMode: Image.PreserveAspectFit
    }

    // bullet movement from player position towards mouse position
    MovementAnimation {
      id: movementX
      target: parent
      property: "x"
      velocity: velocityX * speed
      running: true
      minPropertyValue: -parent.width
      maxPropertyValue: gameScene.gameWindowAnchorItem.width
      onLimitReached: {
          removeEntity();
      }
    }

    MovementAnimation {
      id: movementY
      target: parent
      property: "y"
      velocity: velocityY * speed
      running: true
      minPropertyValue: -parent.height
      maxPropertyValue: gameScene.gameWindowAnchorItem.height
      onLimitReached: {
          removeEntity();
      }
    }

    CircleCollider {
      radius: parent.height/2
      anchors.centerIn: parent
      bodyType: Body.Dynamic
    }

}
