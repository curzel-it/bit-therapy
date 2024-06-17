#include "linear_movement.h"

#include <iostream>

#include "geometry.h"

void LinearMovement::update(long timeSinceLastUpdate, Entity * entity) {
    std::cout << "ape x " << entity->frame.x << std::endl;
    auto offset = entity->direction * entity->speed * timeSinceLastUpdate;
    auto updatedFrame = entity->frame.offset(offset);
    entity->frame = updatedFrame;
}