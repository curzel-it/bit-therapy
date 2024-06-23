#include <gtest/gtest.h>
#include <string>
#include <vector>

#include "../game/game.h"

#include "screens.h"

const Rect frame(0, 0, 0, 0);

const std::vector<Screen> listOfScreens({
    Screen("display 1", frame),
    Screen("display 2", frame),
    Screen("orange", frame),
    Screen("banana", frame),
    Screen("apple", frame),
    Screen("juicyapple", frame),
    Screen("apple co", frame)
});

const std::vector<Screen> screensApples({
    Screen("apple", frame),
    Screen("juicyapple", frame),
    Screen("apple co", frame)
});

const std::vector<Screen> screensDisplay({
    Screen("display 1", frame),
    Screen("display 2", frame),
});

const std::vector<Screen> screensJ({
    Screen("juicyapple", frame),
});

TEST(ScreensTests, CanFilterListOfScreensByNamePart) {
    auto apples = filteredByNameParts(listOfScreens, std::vector<std::string>({"apple"}));
    EXPECT_EQ(apples, screensApples);
    
    auto displays = filteredByNameParts(listOfScreens, std::vector<std::string>({"display"}));
    EXPECT_EQ(displays, screensDisplay);
    
    auto j = filteredByNameParts(listOfScreens, std::vector<std::string>({"j"}));
    EXPECT_EQ(j, screensJ);
};

TEST(ScreensTests, FilteringIsNotCaseSensitive) {    
    auto displays = filteredByNameParts(listOfScreens, std::vector<std::string>({"DisplAY"}));
    EXPECT_EQ(displays, screensDisplay);
}

TEST(ScreensTests, CanUseMultipleNameParts) {    
    auto results = filteredByNameParts(listOfScreens, std::vector<std::string>({"orange", "apple"}));

    const std::vector<Screen> expected({
        Screen("orange", frame),
        Screen("apple", frame),
        Screen("juicyapple", frame),
        Screen("apple co", frame)
    });
    EXPECT_EQ(results, expected);
}