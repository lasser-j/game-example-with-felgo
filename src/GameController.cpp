#include "GameController.hpp"

#include <QtMath>
#include <QRandomGenerator>

GameController::GameController(QObject* parent)
    : QObject(parent) {
}

// invokable game actions

void GameController::startGame()
{
    setGameRunning(true); // Reset state
}

void GameController::gameOver()
{
    setGameRunning(false);
}

// private helper functions

void GameController::setGameRunning(bool v)
{
    if (m_gameRunning == v) return;
    m_gameRunning = v;
    emit gameRunningChanged();
}
