#pragma once

#include <chrono>

#include "../game/game.h"

class BounceWhenLateralBoundIsHit : public EntityCapability {
    double leftBound;
    double rightBound;

public:
    BounceWhenLateralBoundIsHit(double leftBound, double rightBound);

    void update(std::chrono::milliseconds timeSinceLastUpdate, Entity * entity) override;
};
