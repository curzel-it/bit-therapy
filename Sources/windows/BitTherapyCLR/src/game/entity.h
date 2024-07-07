#ifndef ENTITY_H
#define ENTITY_H

#include <chrono>
#include <memory>
#include <string>
#include <vector>

#include "geometry.h"
#include "../species/species.h"
#include "../sprites/sprites.h"

class EntityCapability;

class Entity {    
private:
    double fps;
    const SpriteSet* spriteSet;
    std::vector<std::shared_ptr<EntityCapability>> capabilities;
    Sprite currentSprite;

    void setupSpeed(double settingsSpeedMultiplier);

public:
    uint32_t id;
    Rect frame;
    Vector2d direction;
    double speed;
    const Species* species;

    Entity(
        uint32_t id,
        double fps, 
        double settingsSpeedMultiplier,
        const Species* species,
        const SpriteSet* spriteSet,
        Rect frame
    );
    
    const std::string currentSpriteFrame() const;

    void update(std::chrono::milliseconds timeSinceLastUpdate);
    void addCapability(std::shared_ptr<EntityCapability> capability);
    
    uint32_t changeSprite(const std::string& animationName);

    std::string description() const;
};

class EntityCapability {
public:
    virtual ~EntityCapability() = default;
    virtual void update(std::chrono::milliseconds timeSinceLastUpdate, Entity * entity) {};
};

#endif
