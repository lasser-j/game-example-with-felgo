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

signals:
    void gameRunningChanged();
    void scoreChanged();


private:
    // game state
    bool m_gameRunning      = false;    // pause the game until player clicks
    unsigned int m_score    = 0U;       // score dependent on how many enemies are shot

    // constants
    static constexpr int k_delayInterval = 500;  // delay for game over to not accidentally dismiss the screen in ms

    // timers
    QTimer m_delayTimer; // delay timer for game over to not accidentally dismiss the screen

    // private helper functions
    void setGameRunning(bool v);
    void setScore(unsigned int v);
};
