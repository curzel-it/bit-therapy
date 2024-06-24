#include <gtest/gtest.h>
#include <chrono>

#include "../game/game.h"

#include "gravity.h"
#include "linear_movement.h"

TEST(GravityTests, CanChangeEntityDirection) {
    Species species("test", 100.0, 1.0);
    SpriteSet sprites;

    Entity* entity = new Entity(1.0, 100.0, 1.0, &species, &sprites, Rect(0.0, 0.0, 100.0, 100.0));
    entity->direction = Vector2d(1.0, 0.0);
    
    Gravity gravity;
    gravity.update(std::chrono::milliseconds(100), entity);
    EXPECT_EQ(entity->direction.y, 1.0);
};