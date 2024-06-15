cmake_minimum_required(VERSION 3.10)

# Set the project name and version
project(BitTherapy VERSION 1.0)

# Specify the C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Find the Qt package
find_package(Qt6 COMPONENTS Widgets REQUIRED)  # Change Qt6 to Qt5 if you are using Qt5

# Collect all regular .cpp files in the src directory but exclude *_tests.cpp files
file(GLOB MAIN_SOURCES "src/*.cpp")
list(FILTER MAIN_SOURCES EXCLUDE REGEX ".*_tests\\.cpp$")

# Add executable for the main application
add_executable(Main ${MAIN_SOURCES})
target_link_libraries(Main Qt6::Widgets)  # Link against the Qt Widgets module

# Google Test setup
enable_testing()
find_package(GTest REQUIRED)
include(GoogleTest)

# Collect all test .cpp files in the src directory
file(GLOB TEST_SOURCES "src/*.cpp")
list(FILTER TEST_SOURCES EXCLUDE REGEX ".*main\\.cpp$")

# Add executable for the tests
add_executable(Test ${TEST_SOURCES})
target_link_libraries(Test GTest::GTest GTest::Main Qt6::Widgets)  # Also link tests against Qt Widgets

# Add the test to be run by CMake's testing system
gtest_discover_tests(Test)
