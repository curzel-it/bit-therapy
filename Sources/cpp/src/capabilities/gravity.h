#pragma once

#include <chrono>

#include "../game/game.h"

class Gravity : public EntityCapability {
public:
    void update(std::chrono::milliseconds timeSinceLastUpdate, Entity * entity) override;
};
