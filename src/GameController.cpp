#include "GameController.hpp"

#include <QtMath>
#include <QRandomGenerator>

GameController::GameController(QObject* parent)
    : QObject(parent) {
    // Delay timer: single-shot, guards against accidental restart clicks.
    m_delayTimer.setSingleShot(true);
    m_delayTimer.setInterval(k_delayInterval);
}

// invokable game actions

void GameController::startGame()
{
    setScore(0U); // reset score
    setGameRunning(true); // reset state
}

void GameController::gameOver()
{
    setGameRunning(false);
    m_delayTimer.start();
}

void GameController::incrementScore()
{
    setScore(m_score + 1U);
}

// private helper functions

void GameController::setGameRunning(bool v)
{
    if (m_gameRunning == v) return;
    m_gameRunning = v;
    emit gameRunningChanged();
}

void GameController::setScore(unsigned int v)
{
    if (m_score == v) return;
    m_score = v;
    emit scoreChanged();
}
