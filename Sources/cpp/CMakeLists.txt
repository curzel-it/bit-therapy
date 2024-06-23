cmake_minimum_required(VERSION 3.10)

project(BitTherapy VERSION 1.0)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED True)

include_directories("src")
include_directories("src/sprites")
include_directories("src/utils")

# Get all sources except tests
file(GLOB MAIN_SOURCES "src/*.cpp")
list(FILTER MAIN_SOURCES EXCLUDE REGEX ".*_tests\\.cpp$")

file(GLOB SPRITES_SOURCES "src/sprites/*.cpp")
list(FILTER SPRITES_SOURCES EXCLUDE REGEX ".*_tests\\.cpp$")

file(GLOB UTILS_SOURCES "src/utils/*.cpp")
list(FILTER UTILS_SOURCES EXCLUDE REGEX ".*_tests\\.cpp$")

# Qt
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)
find_package(Qt6 COMPONENTS Widgets REQUIRED)

# Json
find_package(nlohmann_json 3.2.0 REQUIRED)

# App executable
add_executable(Main ${MAIN_SOURCES} ${SPRITES_SOURCES} ${UTILS_SOURCES})
target_link_libraries(Main PRIVATE nlohmann_json::nlohmann_json Qt6::Widgets)

# Google Test
enable_testing()
find_package(GTest REQUIRED)
include(GoogleTest)

# Get all sources except main 
file(GLOB TEST_SOURCES "src/*.cpp")
list(FILTER TEST_SOURCES EXCLUDE REGEX ".*main\\.cpp$")

file(GLOB TEST_SPRITES_SOURCES "src/species/*.cpp")

file(GLOB TEST_UTILS_SOURCES "src/utils/*.cpp")

# Test executable
add_executable(Test ${TEST_SOURCES}  ${TEST_SPRITES_SOURCES} ${TEST_UTILS_SOURCES})
target_link_libraries(Test GTest::GTest GTest::Main Qt6::Widgets)

# Test discovery
gtest_discover_tests(Test)
