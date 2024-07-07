#include "sprite.h"
#include "sprite_set.h"

#include <iostream>
#include <string>
#include <vector>

SpriteSet::SpriteSet(
    const std::map<std::string, std::vector<std::string>> animations
) : animations(animations) {}

SpriteSet::SpriteSet() : 
    animations(std::map<std::string, std::vector<std::string>>({})) {}

Sprite SpriteSet::sprite(const std::string animationName, double fps) const {
    auto frames = spriteFrames(animationName);
    Sprite sprite(animationName, frames, fps);
    return sprite;
}

const std::vector<std::string> SpriteSet::spriteFrames(const std::string animationName) const {
    if (auto iter = animations.find(animationName); iter != animations.end()) {
       return iter->second;
    }
    return {""};
}