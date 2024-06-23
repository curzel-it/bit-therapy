#ifndef SPECIES_H
#define SPECIES_H

#include <string>

#include "sprites/sprites.h"

class Species {
public:
    std::string id;
    double speed;
    double scale;
    SpriteSet spriteSet;

    Species(
        std::string id,
        double speed,
        double scale
    );

    Species(
        std::string id,
        double speed,
        double scale,
        SpriteSet spriteSet
    );
};

#endif
