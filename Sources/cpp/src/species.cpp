#include "species.h"
#include "sprites/sprites.h"

Species::Species(
    std::string id,
    double speed,
    double scale
) : id(id), speed(speed), scale(scale), spriteSet(SpriteSet({})) {}

Species::Species(
    std::string id,
    double speed,
    double scale,
    SpriteSet spriteSet
) : id(id), speed(speed), scale(scale), spriteSet(spriteSet) {}