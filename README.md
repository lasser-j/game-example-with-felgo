# Invasion – Simple Game Example with Felgo

This repository contains a small cross-platform shooter game called **Invasion**, created using [Felgo](https://felgo.com).

It is intended as a step-by-step example for learning how to build games with Felgo, including modular entities, animations, collision detection, and game logic - how to refactor such a project towards a C++/QML Model-View architecture, and how to unit-test the resulting C++ logic with QTest.

## Versions

| Version | Description |
|---|---|
| [v1.0-qml-only](https://github.com/lasser-j/game-example-with-felgo/tree/v1.0-qml-only) | Pure QML/JS implementation |
| [v2.0-cpp-refactor](https://github.com/lasser-j/game-example-with-felgo/tree/v2.0-cpp-refactor) | Game logic extracted into a C++ `GameController`, QML reduced to UI and Felgo-specific entity management |
| [v2.1-unit-tests](https://github.com/lasser-j/game-example-with-felgo/tree/v2.1-unit-tests) | v2.0-cpp-refactor + QTest unit test suite for `GameController`, CMake `BUILD_TESTS` option, GitHub Actions CI |

## Demo & Documentation

The complete **HTML documentation** of all tutorials is included in this repository.
You can view it online via GitHub Pages:

- [Tutorial: Building the game with Felgo/QML](https://lasser-j.github.io/game-example-with-felgo/html/how-to-create-a-simple-game-with-felgo.html)
- [Tutorial: Refactoring to C++ (Model/View)](https://lasser-j.github.io/game-example-with-felgo/html/refactoring-cpp-model-view.html)
- [Tutorial: Unit Testing GameController with QTest](https://lasser-j.github.io/game-example-with-felgo/html/testing-gamecontroller.html)

Or locally, download **docs/html/** and open the respective HTML file in your browser.

## Unit Tests

`GameController` (the C++ game logic introduced in v2.0) has a QTest-based unit test suite under `tests/`, independent of the Felgo SDK. It runs automatically on every push via GitHub Actions.
![GameController Tests](https://github.com/lasser-j/game-example-with-felgo/actions/workflows/tests.yml/badge.svg)

To build and run it locally:

```bash
cmake -S . -B build -DBUILD_GAME=OFF -DBUILD_TESTS=ON
cmake --build build --target test_gamecontroller
ctest --test-dir build --output-on-failure
```
