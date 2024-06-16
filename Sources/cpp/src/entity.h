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
    Entity(double fps, std::string species, SpriteSet spriteSet);
    
    void update(long timeSinceLastUpdate);
    void changeSprite(std::string animationName);
};

#endif
