#ifndef ENTITY_H
#define ENTITY_H

#include <string>
#include <vector>

#include "sprites.h"
#include "sprite_set.h"

class Entity {    
private:
    double fps;
    std::string species;
    SpriteSet spriteSet;
    Sprite currentSprite;

public:
    std::string tag;

    Entity(double fps, std::string species, SpriteSet spriteSet);
    
    const std::string speciesId() const;

    void update(long timeSinceLastUpdate);
    void changeSprite(std::string animationName);

    std::string description() const;
};

#endif
