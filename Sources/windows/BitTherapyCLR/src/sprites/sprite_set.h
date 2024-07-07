#pragma once

#include <cmath>
#include <map>
#include <string>
#include <vector>
#include "sprite.h"

struct SpriteSet {
private:
    std::map<std::string, std::vector<std::string>> animations;

public:
    SpriteSet(const std::map<std::string, std::vector<std::string>> animations);    
    SpriteSet();
    
    const std::vector<std::string> spriteFrames(const std::string animationName) const;

    Sprite sprite(const std::string animationName, double fps) const;
};
