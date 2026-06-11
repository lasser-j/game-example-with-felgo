#include "GameController.hpp"

#include <QtMath>
#include <QRandomGenerator>

GameController::GameController(QObject* parent)
    : QObject(parent) {
    // Delay timer: single-shot, guards against accidental restart clicks.
    m_delayTimer.setSingleShot(true);
    m_delayTimer.setInterval(k_delayInterval);

    // Spawn timer: fires repeatedly while game is running.
    // interval is updated dynamically in recalculateDifficulty().
    m_spawnTimer.setInterval(k_initEnemySpawnInterval);
    connect(&m_spawnTimer, &QTimer::timeout,
            this, &GameController::onSpawnTimerTriggered);
}

// invokable game actions

void GameController::startGame() {
    setScore(0U); // reset score
    setGameRunning(true); // reset state

    // reset spawn timer
    m_spawnTimer.setInterval(k_initEnemySpawnInterval);
    m_spawnTimer.start();
}

void GameController::gameOver() {
    setGameRunning(false);
    m_spawnTimer.stop();
    m_delayTimer.start();
}

void GameController::incrementScore() {
    setScore(m_score + 1U);
    recalculateDifficulty();
}

void GameController::updatePlayerPosition(const qreal x, const qreal y, const qreal w, const qreal h) {
    m_playerX = x;
    m_playerY = y;
    m_playerW = w;
    m_playerH = h;
}

void GameController::setSceneDimensions(const qreal w, const qreal h) {
    m_sceneWidth  = w;
    m_sceneHeight = h;
}

QVariantMap GameController::calculateMovementParameters(
    qreal x, qreal y, qreal destX, qreal destY) const {
    // calculate direction from origin towards destination
    qreal dx = destX - x;
    qreal dy = destY - y;
    const qreal len = qSqrt(dx * dx + dy * dy);
    dx /= len;
    dy /= len;

    // create properties for movement animation
    // x/y: start position of bullet - player position moved slightly into direction of mouse click
    // velocityX/Y: direction towards mouse position, used for moving the bullet
    return QVariantMap{
        {"x",         x},
        {"y",         y},
        {"velocityX", dx},
        {"velocityY", dy}
    };
}

// private functions

void GameController::onSpawnTimerTriggered() {
    // enemies should appear on a random side, except at the bottom
    const int side = static_cast<int>(
        QRandomGenerator::global()->bounded(3));

    qreal x = 0.0;
    qreal y = 0.0;

    switch (side) {
    case 0: // top
        x = QRandomGenerator::global()->generateDouble() * m_sceneWidth;
        y = -m_playerW;
        break;
    case 1: // left
        x = -m_playerW;
        y = QRandomGenerator::global()->generateDouble() * m_sceneHeight;
        break;
    default: // right
        x = m_sceneWidth + m_playerW;
        y = QRandomGenerator::global()->generateDouble() * m_sceneHeight;
        break;
    }

    // Aim at the centre of the player
    const qreal destX = m_playerX + m_playerW / 2.0;
    const qreal destY = m_playerY + m_playerH / 2.0;

    emit spawnEnemyRequested(calculateMovementParameters(x, y, destX, destY));
}

// private helper functions

void GameController::setGameRunning(const bool v) {
    if (m_gameRunning == v) return;
    m_gameRunning = v;
    emit gameRunningChanged();
}

void GameController::setScore(const unsigned int v) {
    if (m_score == v) return;
    m_score = v;
    emit scoreChanged();
}

void GameController::recalculateDifficulty() {
    // calculate new spawn frequency (enemies spawn faster depending on score)
    const int difficulty = qFloor(m_score / k_difficultyStep);
    const int newInterval = qMax(k_minEnemySpawnInterval,
                                 k_initEnemySpawnInterval - difficulty * k_spawnAcceleration);

    if(newInterval != m_spawnTimer.interval())
        m_spawnTimer.setInterval(newInterval);
}
