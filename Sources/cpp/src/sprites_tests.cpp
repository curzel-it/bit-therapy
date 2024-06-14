#include "sprites.h"

#include <gtest/gtest.h>
#include <vector>
#include <string>

TEST(SpriteTests, CurrentFrame) {
    Sprite sprite({"10", "20", "30"}, 1.0);
    EXPECT_EQ(sprite.current_frame(), "10");
}

TEST(SpriteTests, NextFrameAdvance) {
    Sprite sprite({"10", "20", "30"}, 1.0);

    sprite.update(500);
    EXPECT_EQ(sprite.current_frame(), "10");

    sprite.update(500);
    EXPECT_EQ(sprite.current_frame(), "20");

    sprite.update(1000);
    EXPECT_EQ(sprite.current_frame(), "30");
}

TEST(SpriteTests, NextFrameWithInsufficientTimeDoesNotAdvance) {
    Sprite sprite({"10", "20", "30"}, 1.0);

    sprite.update(300);
    EXPECT_EQ(sprite.current_frame(), "10");

    sprite.update(300);
    EXPECT_EQ(sprite.current_frame(), "10");

    sprite.update(300);
    EXPECT_EQ(sprite.current_frame(), "10");

    sprite.update(300);
    EXPECT_EQ(sprite.current_frame(), "20");

    sprite.update(1000);
    EXPECT_EQ(sprite.current_frame(), "30");
}
