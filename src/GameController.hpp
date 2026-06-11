#pragma once

#include <QObject>
#include <QTimer>
#include <QVariantMap>
#include <QtQml/qqml.h>

class GameController : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool gameRunning     READ isGameRunning  NOTIFY gameRunningChanged)
    Q_PROPERTY(unsigned int  score  READ score          NOTIFY scoreChanged)

public:
    explicit GameController(QObject* parent = nullptr);

    // property readers
    bool isGameRunning() const { return m_gameRunning; }
    unsigned int score() const { return m_score; }

    // invokable game actions

    // resets and (re)starts the game. Call from QML on mouse click.
    Q_INVOKABLE void startGame();
    // stops the game loop. Called internally or from QML on player death.
    Q_INVOKABLE void gameOver();
    // Increments score and recalculates difficulty.
    Q_INVOKABLE void incrementScore();
    // delay for game over to not accidentally dismiss the screen
    Q_INVOKABLE bool isDelayActive() const { return m_delayTimer.isActive(); }

    // set the player position for spawn calculation
    Q_INVOKABLE void updatePlayerPosition(const qreal x, const qreal y, const qreal w, const qreal h);
    // set scene dimensions for spawn calculation
    Q_INVOKABLE void setSceneDimensions(const qreal w, const qreal h);

    // calculates normalised direction vector from origin towards destination.
    Q_INVOKABLE QVariantMap calculateMovementParameters(
        qreal x, qreal y, qreal destX, qreal destY) const;

signals:
    void gameRunningChanged();
    void scoreChanged();

    // emitted by the spawn timer to create enemies in QML's EntityManager.
    void spawnEnemyRequested(const QVariantMap properties);

private:
    // game state
    bool m_gameRunning      = false;    // pause the game until player clicks
    unsigned int m_score    = 0U;       // score dependent on how many enemies are shot

    // constants
    static constexpr int k_initEnemySpawnInterval = 500; // initial spawn interval for enemies in ms
    static constexpr int k_minEnemySpawnInterval  = 200; // // fastest spawn interval for enemies in ms
    static constexpr int k_difficultyStep    = 20;   //  spawn interval for enemies will be increased each difficultyStep score points
    static constexpr int k_spawnAcceleration = 50;   // acceleration for spawning enemies each difficultyStep

    static constexpr int k_delayInterval = 500;  // delay for game over to not accidentally dismiss the screen in ms

    // scene dimensions (used for spawn calculation)
    qreal m_sceneWidth  = 0.0;
    qreal m_sceneHeight = 0.0;

    // player position (used for spawn calculation)
    qreal m_playerX = 0.0;
    qreal m_playerY = 0.0;
    qreal m_playerW = 0.0;
    qreal m_playerH = 0.0;

    // timers
    QTimer m_delayTimer; // delay timer for game over to not accidentally dismiss the screen
    QTimer m_spawnTimer; // spwaner for enemies

    // triggered by spwan timer
    void onSpawnTimerTriggered();

    // private helper functions
    void setGameRunning(const bool v);
    void setScore(const unsigned int v);
    void recalculateDifficulty();
};
