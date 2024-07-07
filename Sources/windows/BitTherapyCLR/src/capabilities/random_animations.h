#pragma once

#include <chrono>

#include "../game/game.h"

class RandomAnimations : public EntityCapability {
private:
    bool isPlayingAnimation;
    int32_t timeToNextAnimation;
    int32_t timeToResumeMovement;

    void scheduleNextAnimation();
    void resumeMovement(Entity * entity);
    void playRandomAnimation(Entity * entity);
    void playAnimation(Entity * entity, const SpeciesAnimation& animation);

public:
    RandomAnimations();

    void update(std::chrono::milliseconds timeSinceLastUpdate, Entity * entity) override;
};
