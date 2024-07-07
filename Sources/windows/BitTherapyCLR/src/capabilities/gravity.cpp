#include "gravity.h"

#include <chrono>
#include <iostream>

#include "../game/game.h"

Gravity::Gravity(double groundY) : 
    gravityAcceleration(Vector2d(0, 9.81)),
    groundY(groundY)
{}

void Gravity::update(std::chrono::milliseconds timeSinceLastUpdate, Entity * entity) {
    if (fabs(entity->direction.x) < 0.0001) {
        return;
    }
    if (entity->frame.maxY() < groundY) {
        double timeStep = timeSinceLastUpdate.count() / 1000.0;
        Vector2d gravityEffect = gravityAcceleration * timeStep;
        auto dragSprite = entity->species->dragPath;

        entity->direction = entity->direction + gravityEffect;        
        entity->changeSprite(dragSprite);
    } else if (entity->direction.y > 0.0) {
        auto dx = entity->direction.x > 0 ? 1.0 : -1.0;
        auto movementSprite = entity->species->movementPath;

        entity->frame.y = groundY - entity->frame.h;
        entity->direction = Vector2d(dx, 0.0);
        entity->changeSprite(movementSprite);
    }
}