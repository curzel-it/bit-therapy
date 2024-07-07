#include "species_model.h"

#include <string>

SpeciesAnimation::SpeciesAnimation(
    std::string id,
    std::string position,
    std::vector<double> size,
    uint32_t requiredLoops
) : 
    id(id),
    position(position),
    size(size),
    requiredLoops(requiredLoops)
{}

Species::Species(std::string id, double speed, double scale) : 
    id(id), 
    speed(speed), 
    scale(scale) 
{
    this->dragPath = "drag";
    this->movementPath = "walk";
    this->zIndex = 0.0;
}
