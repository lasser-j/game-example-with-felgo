import Felgo 4.0
import QtQuick 2.0

import "entities"
import "items"

Scene {
    id: gameScene

    // init, set scene dimension for spawn calculation
    Component.onCompleted: {
        gameController.setSceneDimensions(
            gameWindowAnchorItem.width,
            gameWindowAnchorItem.height)
    }

    PhysicsWorld { } // no need to set gravity, the collider is not physics-based

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

        // connection to player signal
        onHitByEnemy: {
            // freeze the game and stop movement
            gameController.gameOver()
        }

        // set scene dimensions for spawn calculation
        Component.onCompleted: gameController.updatePlayerPosition(
                                   player.x, player.y, player.width, player.height)
    }

    // create bullets at runtime
    EntityManager {
      id: entityManager
      entityContainer: gameScene
    }

    // score text
    OverlayText {
        id: scoreText
        anchors.horizontalCenter: gameWindowAnchorItem.horizontalCenter
        y: 10
        secondaryText: "score: " + gameController.score
    }

    // game over or restart text
    OverlayText {
        id: overlayText
        anchors.centerIn: gameWindowAnchorItem
        visible: !gameController.gameRunning

        primaryText: "pause"
        secondaryText: "click to start"
    }

    // trigger bullet shots when mouse was clicked
    MouseArea {
        anchors.fill: gameWindowAnchorItem
        onPressed: (mouse)=> {
            if(gameController.gameRunning){
                // calculate parameters to move the bullet from the middle of the player toward the mouse position
                var movementProperties = gameController.calculateMovementParameters(player.x + player.width/2,  // x
                                                                     player.y + player.height/2, // y
                                                                     mouse.x, // destX
                                                                     mouse.y  // destY
                                                                     )
                // move bullet a bit outside of the player to not overlap with it
                movementProperties.x += 22*movementProperties.velocityX - 5
                movementProperties.y += 22*movementProperties.velocityY - 5

                var bulletID = entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("entities/Bullet.qml"), movementProperties)
                entityManager.getEntityById(bulletID).enemyHit.connect(function() { gameController.incrementScore() })
            }
            else if(!gameController.isDelayActive()) { // wait for delay before allowing reset the game
                resetGame()
            }
        }
    }

    Connections {
        target: gameController

        // reaction to gameOver() to change overlay-text for next restart.
        function onGameRunningChanged() {
            if (!gameController.gameRunning) {
                // rename overlay text for next game over
                overlayText.primaryText   = "GAME OVER"
                overlayText.secondaryText = "click to restart"
            }
        }

        // create enemies
        function onSpawnEnemyRequested(properties) {
            entityManager.createEntityFromUrlWithProperties(
                Qt.resolvedUrl("entities/Enemy.qml"), properties)
        }
    }

    // helper functions - only minimal JS, UI glue code only

    function resetGame() {
        // delete all enemies and bullets
        entityManager.removeEntitiesByFilter(["enemy","bullet"])

        // (re)start game
        gameController.startGame()
    }
}
