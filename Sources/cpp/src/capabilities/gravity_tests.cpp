#include <gtest/gtest.h>
#include <chrono>

#include "../game/game.h"

#include "gravity.h"

TEST(GravityTests, CanMoveEntityOnUpdate) {
    Species species("test", 100.0, 1.0);
    SpriteSet sprites;

    Entity* entity = new Entity(1.0, 100.0, 1.0, &species, &sprites, Rect(0.0, 0.0, 100.0, 100.0));
    entity->direction = Vector2d(1.0, 0.0);
    
    Gravity lm;

    lm.update(std::chrono::milliseconds(100), entity);
    EXPECT_EQ(entity->frame.y, 300.0);
};