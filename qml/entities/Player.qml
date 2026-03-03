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

    CircleCollider {
      radius: parent.height/2
      anchors.centerIn: parent

      bodyType: Body.Dynamic
    }

}
