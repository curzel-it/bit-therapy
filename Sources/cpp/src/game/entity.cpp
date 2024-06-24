#include "entity.h"

#include <chrono>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

#include "../game/game.h"
#include "../sprites/sprites.h"
#include "../utils/utils.h"

Entity::Entity(
    double fps, 
    double settingsBaseSize, 
    double settingsSpeedMultiplier,
    const Species* species, 
    const SpriteSet* spriteSet, 
    Rect frame
) :
    fps(fps),
    speed(0.0),
    species(species), 
    spriteSet(spriteSet), 
    frame(frame),
    direction(Vector2d(1.0, 0.0)),
    capabilities(std::vector<std::shared_ptr<EntityCapability>>()),
    currentSprite(spriteSet->movementSprite(fps))
{
    setupSpeed(settingsBaseSize, settingsSpeedMultiplier);
    changeSprite(SPRITE_NAME_MOVEMENT); 
}

void Entity::addCapability(std::shared_ptr<EntityCapability> capability) {
    capabilities.push_back(capability);
}

const std::string Entity::currentSpriteFrame() const {
    return currentSprite.currentFrame();
}

const std::string Entity::speciesId() const {
    return species->id;
}

void Entity::update(std::chrono::milliseconds timeSinceLastUpdate) {
    for (auto& capability : capabilities) {
        capability->update(timeSinceLastUpdate, this);
    }
    currentSprite.update(timeSinceLastUpdate);
}

void Entity::changeSprite(std::string animationName) {
    currentSprite = spriteSet->sprite(animationName, fps);
}

std::string Entity::description() const {
    auto spriteName = fileName(currentSpriteFrame());
    std::stringstream ss; 
    ss << species->id << " " << spriteName << " " << frame.description();
    return ss.str();
}

void Entity::setupSpeed(double settingsBaseSize, double settingsSpeedMultiplier) {
    double sizeMultiplier = frame.w / settingsBaseSize;
    speed = 30.0 * species->speed * sizeMultiplier * settingsSpeedMultiplier;
}