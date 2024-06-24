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
    const Species* species;
    const SpriteSet* spriteSet;
    std::vector<std::shared_ptr<EntityCapability>> capabilities;
    Sprite currentSprite;

    void setupSpeed(double settingsBaseSize, double settingsSpeedMultiplier);

public:
    Rect frame;
    Vector2d direction;
    double speed;

    Entity(
        double fps, 
        double settingsBaseSize, 
        double settingsSpeedMultiplier,
        const Species* species,
        const SpriteSet* spriteSet,
        Rect frame
    );
    
    const std::string currentSpriteFrame() const;
    const std::string speciesId() const;

    void update(std::chrono::milliseconds timeSinceLastUpdate);
    void changeSprite(std::string animationName);
    void setFrame(Rect newFrame);
    void addCapability(std::shared_ptr<EntityCapability> capability);

    std::string description() const;
};

class EntityCapability {
public:
    virtual ~EntityCapability() = default;
    virtual void update(std::chrono::milliseconds timeSinceLastUpdate, Entity * entity) {};
};

#endif
