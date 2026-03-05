import Felgo 4.0
import QtQuick 2.0

import "entities"
import "items"

Scene {
    id: gameScene

    property bool gameRunning: false // pause the game until player clicks

    property real score: 0 // score dependent on how many enemies are shot

    property int initEnemySpawnInterval: 500 // initial spawn intervall for enemies
    property int minEnemySpawnInterval: 200 // fastest spawn intervall for enemies
    property int difficultyStep: 20 // spawn intervall for enemies will be increased each difficultyStep score points
    property int spawnAcceleration: 50 // acceleration for spawning enemies each difficultyStep

    property int delayTimerInterval: 500 // delay for game over to not accidentally dismiss the screen

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
        secondaryText: "score: " + score
    }

    // game over or restart text
    OverlayText {
        id: overlayText
        anchors.centerIn: gameWindowAnchorItem
        visible: !gameRunning

        primaryText: "pause"
        secondaryText: "click to start"
    }

    // trigger bullet shots when mouse was clicked
    MouseArea {
        anchors.fill: gameWindowAnchorItem
        onPressed: (mouse)=> {
            if(gameRunning){
                // calculate parameters to move the bullet from the middle of the player towards to the mouse position
                var movementProperties = calculateMovementParameters(player.x + player.width/2,  // x
                                                                     player.y + player.height/2, // y
                                                                     mouse.x, // destX
                                                                     mouse.y  // destY
                                                                     )
                // move bullet a bit outside of the player to not overlap with it
                movementProperties.x += 22*movementProperties.velocityX - 5
                movementProperties.y += 22*movementProperties.velocityY - 5

                entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("entities/Bullet.qml"), movementProperties)
            }
            else if(!delayTimer.running) { // wait for delay before allowing reset the game
                resetGame()
            }
        }
    }

    // spwaner for enemies
    Timer {
        interval: initEnemySpawnInterval
        running: gameRunning
        repeat: true

        onTriggered: {
            // enemies should appear on a random side, except at the bottom
            var side = Math.floor(Math.random() * 3)
            var x, y

            if (side === 0) { // top
                                    x = Math.random() * gameWindowAnchorItem.width
                                    y = -player.width
            } else if (side === 1) { // left
                                    x = -player.width
                                    y = Math.random() * gameWindowAnchorItem.height
            } else { // right
                                    x = gameWindowAnchorItem.width + player.width
                                    y = Math.random() * gameWindowAnchorItem.height
            }

            // calculate parameters to move the bullet towards the mouse position
            var movementProperties = calculateMovementParameters(x, // x
                                                                 y, // y
                                                                 player.x + player.width/2, // destX
                                                                 player.y + player.height/2 // destY
                                                                )

            entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("entities/Enemy.qml"), movementProperties)

            // calculate new spawn frequency (enemies spawn faster depending on score)
            var difficulty = Math.floor(score / difficultyStep)
            interval = Math.max(minEnemySpawnInterval, initEnemySpawnInterval - difficulty * spawnAcceleration)
        }
    }

    // delay timer for game over to not accidentally dismiss the screen
    Timer {
        id: delayTimer
        interval: delayTimerInterval
        running: false
    }

    function calculateMovementParameters(x, y, destX, destY){
        // calculate direction from origin towards destination
        var dx = destX - x
        var dy = destY - y
        var len = Math.sqrt(dx*dx + dy*dy)
        dx /= len
        dy /= len

        // create propeerties for movement animation
        // x/y: start position of bullet - player position moved slightly into direction of mouse click
        // velocityX/Y: direction towards mouse position, used for moving the bullet
        var newEntityProperties = {
            x: x,
            y: y,
            velocityX: dx,
            velocityY: dy
        }

        return newEntityProperties
    }

    function gameOver() {
        // freeze the game and stop movement
        gameRunning = false
        delayTimer.restart()
    }

    function resetGame() {
        // delete all enemies and bullets
        entityManager.removeEntitiesByFilter(["enemy","bullet"])

        score = 0 // reset score

        // rename overlay text for next game over
        overlayText.primaryText = "GAME OVER"
        overlayText.secondaryText = "click to restart"

        // (re)start game
        gameRunning = true
    }
}
