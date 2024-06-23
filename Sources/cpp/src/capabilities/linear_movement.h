#ifndef LINEAR_MOVEMENT_H
#define LINEAR_MOVEMENT_H

#include <chrono>

#include "../game/game.h"

class LinearMovement : public EntityCapability {
public:
    void update(std::chrono::milliseconds timeSinceLastUpdate, Entity * entity) override;
};

#endif
