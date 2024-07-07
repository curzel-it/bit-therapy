#include "bounce_when_lateral_bound_is_hit.h"

#include <chrono>
#include <iostream>

#include "../game/game.h"

BounceWhenLateralBoundIsHit::BounceWhenLateralBoundIsHit(double leftBound, double rightBound) : 
    leftBound(leftBound),
    rightBound(rightBound)
{}

void BounceWhenLateralBoundIsHit::update(std::chrono::milliseconds timeSinceLastUpdate, Entity * entity) {
    if (entity->frame.x < leftBound && entity->direction.x < 0) {
        entity->direction = Vector2d(-1 * entity->direction.x, entity->direction.y);
        entity->frame.x = leftBound;
    } 
    if (entity->frame.maxX() > rightBound && entity->direction.x > 0) {
        entity->direction = Vector2d(-1 * entity->direction.x, entity->direction.y);
        entity->frame.x = rightBound - entity->frame.w;
    }
}