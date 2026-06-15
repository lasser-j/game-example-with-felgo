# Included via add_subdirectory(tests) from the top-level CMakeLists.txt,
# guarded by the BUILD_TESTS option. Only depends on Qt (Core + Test),
# not on Felgo - this allows running the suite with -DBUILD_GAME=OFF
# in environments without a Felgo SDK installation.

find_package(Qt6 REQUIRED COMPONENTS Core Test)

add_executable(test_gamecontroller
    test_gamecontroller.cpp
    ${CMAKE_SOURCE_DIR}/src/GameController.cpp
)

target_include_directories(test_gamecontroller PRIVATE
    ${CMAKE_SOURCE_DIR}/src
)

target_compile_features(test_gamecontroller PRIVATE cxx_std_17)

target_link_libraries(test_gamecontroller PRIVATE Qt6::Core Qt6::Test)

add_test(NAME GameControllerTests COMMAND test_gamecontroller)
