#include "linear_movement.h"

#include <chrono>

#include "../game/game.h"

void LinearMovement::update(std::chrono::milliseconds timeSinceLastUpdate, Entity * entity) {
    auto frameDuration = std::chrono::duration_cast<std::chrono::milliseconds>(timeSinceLastUpdate).count();
    auto offset = entity->direction * entity->speed * frameDuration * 0.001;
    auto updatedFrame = entity->frame.offset(offset);
    entity->frame = updatedFrame;
}