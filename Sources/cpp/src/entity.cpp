#include "entity.h"

#include <string>
#include <vector>

#include "sprites.h"
#include "sprite_set.h"

Entity::Entity(double fps, std::string species, SpriteSet spriteSet) : 
    species(species), 
    spriteSet(spriteSet), 
    fps(fps),
    currentSprite(Sprite({}, fps))
{
    changeSprite(SPRITE_NAME_FRONT); 
}


void Entity::update(long timeSinceLastUpdate) {
    currentSprite.update(timeSinceLastUpdate);
}

void Entity::changeSprite(std::string animationName) {
    currentSprite = spriteSet.sprite(animationName, fps);
}