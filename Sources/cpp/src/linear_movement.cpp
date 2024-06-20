#include "linear_movement.h"

#include <iostream>

#include "geometry.h"

void LinearMovement::update(long timeSinceLastUpdate, Entity * entity) {
    auto offset = entity->direction * entity->speed * timeSinceLastUpdate * 0.001;
    auto updatedFrame = entity->frame.offset(offset);
    entity->frame = updatedFrame;
}