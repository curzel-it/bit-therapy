#include "entity.h"

#include <iostream>
#include <sstream>
#include <string>
#include <vector>

#include "geometry.h"
#include "linear_movement.h"
#include "sprites.h"
#include "sprite_set.h"

Entity::Entity(
    double fps, 
    double speed,
    std::string species, 
    SpriteSet spriteSet, 
    Rect frame
) :
    fps(fps),
    speed(speed),
    species(species), 
    spriteSet(spriteSet), 
    frame(frame),
    direction(Vector2d(1.0, 0.0)),
    capabilities(std::vector<std::shared_ptr<EntityCapability>>()),
    currentSprite(Sprite({}, fps))
{
    changeSprite(SPRITE_NAME_FRONT); 
    std::shared_ptr<LinearMovement> lm = std::make_shared<LinearMovement>();
    capabilities.push_back(lm);
}

const std::string Entity::speciesId() const {
    return species;
}

void Entity::update(long timeSinceLastUpdate) {
    for (auto& capability : capabilities) {
        capability->update(timeSinceLastUpdate, this);
    }
    currentSprite.update(timeSinceLastUpdate);
}

void Entity::changeSprite(std::string animationName) {
    currentSprite = spriteSet.sprite(animationName, fps);
}

std::string Entity::description() const {
    std::stringstream ss; 
    ss << species << " " << frame.description() << std::endl;
    return ss.str();
}
