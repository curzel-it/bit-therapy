#include <gtest/gtest.h>
#include <chrono>

#include "../game/game.h"

#include "linear_movement.h"

TEST(LinearMovementTests, CanMoveEntityHorizontallyOnUpdate) {
    Species species("test", 100.0, 1.0);
    SpriteSet sprites;

    Entity* entity = new Entity(1.0, 100.0, 1.0, &species, &sprites, Rect(0.0, 0.0, 100.0, 100.0));
    entity->direction = Vector2d(1.0, 0.0);
    
    LinearMovement lm;

    lm.update(std::chrono::milliseconds(100), entity);
    EXPECT_EQ(entity->frame.x, 300.0);
};

TEST(LinearMovementTests, CanMoveEntityVerticallyOnUpdate) {
    Species species("test", 100.0, 1.0);
    SpriteSet sprites;

    Entity* entity = new Entity(1.0, 100.0, 1.0, &species, &sprites, Rect(0.0, 0.0, 100.0, 100.0));
    entity->direction = Vector2d(0.0, 1.0);
    
    LinearMovement lm;

    lm.update(std::chrono::milliseconds(100), entity);
    EXPECT_EQ(entity->frame.y, 300.0);
};