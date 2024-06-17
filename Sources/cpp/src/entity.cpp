#include "entity.h"

#include <sstream>
#include <string>
#include <vector>

#include "sprites.h"
#include "sprite_set.h"

Entity::Entity(double fps, std::string species, SpriteSet spriteSet) : 
    tag(""),
    species(species), 
    spriteSet(spriteSet), 
    fps(fps),
    currentSprite(Sprite({}, fps))
{
    changeSprite(SPRITE_NAME_FRONT); 
}

const std::string Entity::speciesId() const {
    return species;
}

void Entity::update(long timeSinceLastUpdate) {
    currentSprite.update(timeSinceLastUpdate);
}

void Entity::changeSprite(std::string animationName) {
    currentSprite = spriteSet.sprite(animationName, fps);
}

std::string Entity::description() const {
    std::stringstream ss; 
    ss << speciesId() << std::endl;
    return ss.str();
}
