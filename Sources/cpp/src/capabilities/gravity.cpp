#include "gravity.h"

#include <chrono>

#include "../game/game.h"

void Gravity::update(std::chrono::milliseconds timeSinceLastUpdate, Entity * entity) {
    entity->direction = Vector2d(0.0, 1.0);
}