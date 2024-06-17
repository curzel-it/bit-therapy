#ifndef ENTITY_H
#define ENTITY_H

#include <memory>
#include <string>
#include <vector>

#include "geometry.h"
#include "sprites.h"
#include "sprite_set.h"

class EntityCapability;

class Entity {    
private:
    double fps;
    std::string species;
    SpriteSet spriteSet;
    Rect frame;
    std::vector<std::shared_ptr<EntityCapability>> capabilities;
    Sprite currentSprite;

public:
    Entity(
        double fps, 
        std::string species, 
        SpriteSet spriteSet, 
        Rect frame
    );
    
    const std::string speciesId() const;

    void update(long timeSinceLastUpdate);
    void changeSprite(std::string animationName);

    std::string description() const;
};

class EntityCapability {
public:
    virtual ~EntityCapability() = default;
    virtual void update(long timeSinceLastUpdate, Entity * entity) {};
};

#endif
