#include "sprite.h"
#include "sprite_set.h"

#include <iostream>
#include <string>
#include <vector>

SpriteSet::SpriteSet(
    const std::vector<std::string> movement, 
    const std::vector<std::string> fall, 
    const std::vector<std::string> front, 
    const std::map<std::string, std::vector<std::string>> animations
) : movement(movement), fall(fall), front(front), animations(animations) {}

SpriteSet::SpriteSet() : 
    movement(std::vector<std::string>({})), 
    fall(std::vector<std::string>({})), 
    front(std::vector<std::string>({})), 
    animations(std::map<std::string, std::vector<std::string>>({})) {}

Sprite SpriteSet::sprite(const std::string animationName, double fps) const {
    auto frames = spriteFrames(animationName);
    Sprite sprite(frames, fps);
    return sprite;
}

Sprite SpriteSet::movementSprite(double fps) const {
    return sprite(SPRITE_NAME_MOVEMENT, fps);
}

Sprite SpriteSet::fallSprite(double fps) const {
    return sprite(SPRITE_NAME_FALL, fps);
}

Sprite SpriteSet::frontSprite(double fps) const {
    return sprite(SPRITE_NAME_FRONT, fps);
}

const std::vector<std::string> SpriteSet::spriteFrames(const std::string animationName) const {
    if (animationName == SPRITE_NAME_MOVEMENT) {
        return movement;
    }
    if (animationName == SPRITE_NAME_FALL) {
        return fall;
    }
    if (animationName == SPRITE_NAME_FRONT) {
        return front;
    }
    if (auto iter = animations.find(animationName); iter != animations.end()) {
       return iter->second;
    }
    return {};
}