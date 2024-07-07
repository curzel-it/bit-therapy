#include "random_animations.h"

#include <chrono>
#include <iostream>

#include "../game/game.h"

RandomAnimations::RandomAnimations() : 
    isPlayingAnimation(false),
    timeToNextAnimation(10000),
    timeToResumeMovement(10000)
{
    scheduleNextAnimation();
}

void RandomAnimations::scheduleNextAnimation() {
    double randomDelaySeconds = 10 + (rand() % 20);
    timeToNextAnimation = uint32_t(randomDelaySeconds * 1000.0);
}

void RandomAnimations::update(std::chrono::milliseconds timeSinceLastUpdate, Entity * entity) {
    auto frameDuration = std::chrono::duration_cast<std::chrono::milliseconds>(timeSinceLastUpdate).count();
    auto isFalling = entity->direction.y != 0;

    if (isPlayingAnimation) {
        timeToResumeMovement -= frameDuration;

        if (timeToResumeMovement < 0) {
            resumeMovement(entity);
            scheduleNextAnimation();
        }
    } else {
        timeToNextAnimation -= frameDuration;

        if (timeToNextAnimation < 0 && !isFalling) {
            playRandomAnimation(entity);
        }
    }
}

void RandomAnimations::resumeMovement(Entity * entity) {
    entity->changeSprite(entity->species->movementPath);
    entity->direction = Vector2d(1.0, 0.0);
    isPlayingAnimation = false;
}

void RandomAnimations::playRandomAnimation(Entity * entity) {
    if (entity->species->animations.size() == 0) {
        return;
    }
    int random = rand() % entity->species->animations.size();
    auto animation = entity->species->animations[random];
    playAnimation(entity, animation);
}

void RandomAnimations::playAnimation(Entity * entity, const SpeciesAnimation& animation) {
    entity->direction = Vector2d(0.0, 0.0);
    auto loopDuration = entity->changeSprite(animation.id);
    timeToResumeMovement = loopDuration * animation.requiredLoops;
    isPlayingAnimation = true;
}