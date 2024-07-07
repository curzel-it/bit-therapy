#pragma once

#include <chrono>

#include "../game/game.h"

class Gravity : public EntityCapability {
    Vector2d gravityAcceleration;
    double groundY;

public:
    Gravity(double groundY);

    void update(std::chrono::milliseconds timeSinceLastUpdate, Entity * entity) override;
};
