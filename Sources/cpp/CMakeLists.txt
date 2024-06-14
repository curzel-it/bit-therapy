cmake_minimum_required(VERSION 3.10)

# Set the project name and version
project(BitTherapy VERSION 1.0)

# Specify the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Collect all regular .cpp files in the src directory but exclude *_tests.cpp files
file(GLOB MAIN_SOURCES "src/*.cpp")
list(FILTER MAIN_SOURCES EXCLUDE REGEX ".*_tests\\.cpp$")

# Add executable for the main application
add_executable(Main ${MAIN_SOURCES})

# Google Test setup
enable_testing()
find_package(GTest REQUIRED)
include(GoogleTest)

# Collect all test .cpp files in the src directory
file(GLOB TEST_SOURCES "src/*.cpp")
list(FILTER TEST_SOURCES EXCLUDE REGEX ".*main\\.cpp$")

# Add executable for the tests
add_executable(Test ${TEST_SOURCES})
target_link_libraries(Test GTest::GTest GTest::Main)

# Add the test to be run by CMake's testing system
gtest_discover_tests(Test)
