cmake_minimum_required(VERSION 3.10)

project(BitTherapy VERSION 1.0)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Get all sources except tests
file(GLOB MAIN_SOURCES "src/*.cpp")
list(FILTER MAIN_SOURCES EXCLUDE REGEX ".*_tests\\.cpp$")

# Qt
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)
find_package(Qt6 COMPONENTS Widgets REQUIRED)

# Json
find_package(nlohmann_json 3.2.0 REQUIRED)

# App executable
add_executable(Main ${MAIN_SOURCES})
target_link_libraries(Main PRIVATE nlohmann_json::nlohmann_json Qt6::Widgets)

# Google Test
enable_testing()
find_package(GTest REQUIRED)
include(GoogleTest)

# Get all sources except main 
file(GLOB TEST_SOURCES "src/*.cpp")
list(FILTER TEST_SOURCES EXCLUDE REGEX ".*main\\.cpp$")

# Test executable
add_executable(Test ${TEST_SOURCES})
target_link_libraries(Test GTest::GTest GTest::Main Qt6::Widgets)  # Also link tests against Qt Widgets

# Test discovery
gtest_discover_tests(Test)
