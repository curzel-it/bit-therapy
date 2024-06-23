#pragma once

#include <cmath>
#include <map>
#include <string>
#include <vector>
#include "sprite.h"

struct SpriteSet {
private:
    std::vector<std::string> movement;
    std::vector<std::string> fall;
    std::vector<std::string> front;
    std::map<std::string, std::vector<std::string>> animations;

public:
    SpriteSet(
        const std::vector<std::string> movement, 
        const std::vector<std::string> fall, 
        const std::vector<std::string> front, 
        const std::map<std::string, std::vector<std::string>> animations
    );    
    SpriteSet();
    
    const std::vector<std::string> spriteFrames(const std::string animationName) const;

    Sprite sprite(const std::string animationName, double fps) const;

    Sprite movementSprite(double fps) const;
    Sprite fallSprite(double fps) const;
    Sprite frontSprite(double fps) const;
};

const std::string SPRITE_NAME_MOVEMENT = "movement";
const std::string SPRITE_NAME_FALL = "fall";
const std::string SPRITE_NAME_FRONT = "front";
