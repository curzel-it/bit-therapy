#include "sprite.h"

#include <chrono>
#include <gtest/gtest.h>
#include <vector>
#include <string>

TEST(SpriteTests, CurrentFrame) {
    Sprite sprite({"10", "20", "30"}, 1.0);
    EXPECT_EQ(sprite.currentFrame(), "10");
}

TEST(SpriteTests, NextFrameAdvance) {
    Sprite sprite({"10", "20", "30"}, 1.0);

    sprite.update(std::chrono::milliseconds(500));
    EXPECT_EQ(sprite.currentFrame(), "10");

    sprite.update(std::chrono::milliseconds(500));
    EXPECT_EQ(sprite.currentFrame(), "20");

    sprite.update(std::chrono::milliseconds(1000));
    EXPECT_EQ(sprite.currentFrame(), "30");
}

TEST(SpriteTests, NextFrameWithInsufficientTimeDoesNotAdvance) {
    Sprite sprite({"10", "20", "30"}, 1.0);

    sprite.update(std::chrono::milliseconds(300));
    EXPECT_EQ(sprite.currentFrame(), "10");

    sprite.update(std::chrono::milliseconds(300));
    EXPECT_EQ(sprite.currentFrame(), "10");

    sprite.update(std::chrono::milliseconds(300));
    EXPECT_EQ(sprite.currentFrame(), "10");

    sprite.update(std::chrono::milliseconds(300));
    EXPECT_EQ(sprite.currentFrame(), "20");

    sprite.update(std::chrono::milliseconds(1000));
    EXPECT_EQ(sprite.currentFrame(), "30");
}
