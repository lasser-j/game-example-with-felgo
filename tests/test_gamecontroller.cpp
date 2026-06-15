#include <QtTest>
#include "GameController.hpp"

class TestGameController : public QObject
{
    Q_OBJECT

private slots:
    // calculateMovementParameters()
    void calculateMovementParameters_normalizesDirection();
    void calculateMovementParameters_preservesOrigin();

    // startGame() / gameOver()
    void startGame_resetsScoreAndSetsGameRunning();
    void startGame_emitsSignalsOnlyOnChange();
    void gameOver_setsGameRunningFalseAndStartsDelay();

    // incrementScore() / difficulty
    void incrementScore_increasesScoreByOne();
    void incrementScore_emitsScoreChanged();

    // isDelayActive()
    void isDelayActive_falseBeforeGameOver();
    void isDelayActive_trueImmediatelyAfterGameOver();

    // spawnEnemyRequested
    void spawnEnemyRequested_firesAfterStartGameWithValidProperties();

    // recalculateDifficulty (indirect, via incrementScore + spawn timing)
    void incrementScore_reducesSpawnIntervalToMinimumAtHighDifficulty();
};

// ---------------------------------------------------------------------------
// calculateMovementParameters()
// ---------------------------------------------------------------------------

void TestGameController::calculateMovementParameters_normalizesDirection()
{
    GameController controller;

    // 3-4-5 triangle: direction from (0,0) to (3,4) has length 5
    const auto result = controller.calculateMovementParameters(0, 0, 3, 4);

    QCOMPARE(result["velocityX"].toReal(), 0.6); // 3/5
    QCOMPARE(result["velocityY"].toReal(), 0.8); // 4/5
}

void TestGameController::calculateMovementParameters_preservesOrigin()
{
    GameController controller;

    // x/y in the result must be the *origin*, unchanged, regardless of direction
    const auto result = controller.calculateMovementParameters(10, 20, 100, 200);

    QCOMPARE(result["x"].toReal(), 10.0);
    QCOMPARE(result["y"].toReal(), 20.0);
}

// ---------------------------------------------------------------------------
// startGame() / gameOver()
// ---------------------------------------------------------------------------

void TestGameController::startGame_resetsScoreAndSetsGameRunning()
{
    GameController controller;

    controller.incrementScore();
    controller.incrementScore();
    QCOMPARE(controller.score(), 2U);

    controller.startGame();

    QCOMPARE(controller.score(), 0U);
    QCOMPARE(controller.isGameRunning(), true);
}

void TestGameController::startGame_emitsSignalsOnlyOnChange()
{
    GameController controller;

    QSignalSpy runningSpy(&controller, &GameController::gameRunningChanged);
    QSignalSpy scoreSpy(&controller, &GameController::scoreChanged);

    // first call: gameRunning false -> true, score already 0 -> 0
    controller.startGame();

    QCOMPARE(runningSpy.count(), 1);
    QCOMPARE(scoreSpy.count(), 0); // score was already 0, setScore() must not emit

    // second call without score change in between: gameRunning true -> true
    controller.startGame();

    QCOMPARE(runningSpy.count(), 1); // still 1 - no redundant emit
    QCOMPARE(scoreSpy.count(), 0);
}

void TestGameController::gameOver_setsGameRunningFalseAndStartsDelay()
{
    GameController controller;
    controller.startGame();

    QSignalSpy runningSpy(&controller, &GameController::gameRunningChanged);

    controller.gameOver();

    QCOMPARE(controller.isGameRunning(), false);
    QCOMPARE(runningSpy.count(), 1);
    QCOMPARE(controller.isDelayActive(), true);
}

// ---------------------------------------------------------------------------
// incrementScore() / difficulty
// ---------------------------------------------------------------------------

void TestGameController::incrementScore_increasesScoreByOne()
{
    GameController controller;
    controller.startGame(); // score = 0

    controller.incrementScore();
    QCOMPARE(controller.score(), 1U);

    controller.incrementScore();
    QCOMPARE(controller.score(), 2U);
}

void TestGameController::incrementScore_emitsScoreChanged()
{
    GameController controller;

    QSignalSpy scoreSpy(&controller, &GameController::scoreChanged);

    controller.incrementScore();
    controller.incrementScore();

    QCOMPARE(scoreSpy.count(), 2);
    QCOMPARE(controller.score(), 2U);
}

// ---------------------------------------------------------------------------
// isDelayActive()
// ---------------------------------------------------------------------------

void TestGameController::isDelayActive_falseBeforeGameOver()
{
    GameController controller;
    controller.startGame();

    QCOMPARE(controller.isDelayActive(), false);
}

void TestGameController::isDelayActive_trueImmediatelyAfterGameOver()
{
    GameController controller;
    controller.startGame();
    controller.gameOver();

    // delay timer is single-shot and was just started - must be active immediately
    QCOMPARE(controller.isDelayActive(), true);
}

// ---------------------------------------------------------------------------
// spawnEnemyRequested
// ---------------------------------------------------------------------------

void TestGameController::spawnEnemyRequested_firesAfterStartGameWithValidProperties()
{
    GameController controller;
    controller.setSceneDimensions(960, 640);
    controller.updatePlayerPosition(480, 600, 39, 39);

    QSignalSpy spawnSpy(&controller, &GameController::spawnEnemyRequested);

    controller.startGame();

    // k_initEnemySpawnInterval = 500ms; generous timeout to avoid CI flakiness
    QVERIFY(spawnSpy.wait(1000));
    QCOMPARE(spawnSpy.count(), 1);

    const auto properties = spawnSpy.at(0).at(0).toMap();
    QVERIFY(properties.contains("x"));
    QVERIFY(properties.contains("y"));
    QVERIFY(properties.contains("velocityX"));
    QVERIFY(properties.contains("velocityY"));

    // direction vector must be normalized
    const qreal vx = properties["velocityX"].toReal();
    const qreal vy = properties["velocityY"].toReal();
    QVERIFY(qAbs(vx*vx + vy*vy - 1.0) < 1e-9);
}

// ---------------------------------------------------------------------------
// recalculateDifficulty (indirect, via incrementScore + spawn timing)
// ---------------------------------------------------------------------------

void TestGameController::incrementScore_reducesSpawnIntervalToMinimumAtHighDifficulty()
{
    GameController controller;
    controller.setSceneDimensions(960, 640);
    controller.updatePlayerPosition(480, 600, 39, 39);

    QSignalSpy spawnSpy(&controller, &GameController::spawnEnemyRequested);

    controller.startGame(); // spawn interval starts at 500ms

    // consume the first spawn, fired at the initial 500ms interval
    QVERIFY(spawnSpy.wait(1000));
    spawnSpy.clear();

    // 120 increments = 6 * k_difficultyStep (20)
    // -> difficulty = 6, interval = max(k_minEnemySpawnInterval=200, 500 - 6*50) = 200ms
    for (int i = 0; i < 120; ++i)
        controller.incrementScore();

    // 350ms is between the new (200ms) and old (500ms) interval:
    // only passes if recalculateDifficulty() actually reduced the spawn interval
    QVERIFY(spawnSpy.wait(350));
}

QTEST_MAIN(TestGameController)
#include "test_gamecontroller.moc"
