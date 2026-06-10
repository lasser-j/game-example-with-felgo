#pragma once

#include <QObject>
#include <QTimer>
#include <QVariantMap>
#include <QtQml/qqml.h>

class GameController : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool gameRunning READ isGameRunning NOTIFY gameRunningChanged)

public:
    explicit GameController(QObject* parent = nullptr);

    // property readers
    bool isGameRunning() const { return m_gameRunning; }

    // invokable game actions

    // resets and (re)starts the game. Call from QML on mouse click.
    Q_INVOKABLE void startGame();
    // stops the game loop. Called internally or from QML on player death.
    Q_INVOKABLE void gameOver();

signals:
    void gameRunningChanged();

private:
    // game state
    bool m_gameRunning = false; // pause the game until player clicks

    // private helper functions
    void setGameRunning(bool v);
};
