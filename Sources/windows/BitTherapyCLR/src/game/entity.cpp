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
    uint32_t id,
    double fps, 
    double settingsSpeedMultiplier,
    const Species* species, 
    const SpriteSet* spriteSet, 
    Rect frame
) :
    id(id),
    fps(fps),
    speed(0.0),
    species(species), 
    spriteSet(spriteSet), 
    frame(frame),
    direction(Vector2d(1.0, 0.0)),
    capabilities(std::vector<std::shared_ptr<EntityCapability>>()),
    currentSprite(Sprite("", std::vector<std::string>({}), 1.0))
{
    auto movementSprite = species->movementPath;
    setupSpeed(settingsSpeedMultiplier);
    changeSprite(movementSprite); 
}

void Entity::addCapability(std::shared_ptr<EntityCapability> capability) {
    capabilities.push_back(capability);
}

const std::string Entity::currentSpriteFrame() const {
    return currentSprite.currentFrame();
}

void Entity::update(std::chrono::milliseconds timeSinceLastUpdate) {
    for (auto& capability : capabilities) {
        capability->update(timeSinceLastUpdate, this);
    }
    currentSprite.update(timeSinceLastUpdate);
}

uint32_t Entity::changeSprite(const std::string& animationName) {
    if (currentSprite.animationName != animationName) {
        currentSprite = spriteSet->sprite(animationName, fps);
    }
    return 1000 * currentSprite.numberOfFrames() / fps;
}

std::string Entity::description() const {
    auto spriteName = fileName(currentSpriteFrame());
    std::stringstream ss; 

    ss << "Entity @ " << this << std::endl;
    ss << "  Species: " << species->id << std::endl;
    ss << "  Sprite: " << spriteName << std::endl;
    ss << "  dx: " << direction.x << std::endl;
    ss << "  dy: " << direction.y << std::endl;
    ss << "  x: " << frame.x << std::endl;
    ss << "  y: " << frame.y << std::endl;
    ss << "  w: " << frame.w << std::endl;
    ss << "  h: " << frame.h << std::endl;
    return ss.str();
}

void Entity::setupSpeed(double settingsSpeedMultiplier) {
    speed = 30.0 * species->speed * settingsSpeedMultiplier;
}