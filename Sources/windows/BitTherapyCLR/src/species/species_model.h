#pragma once

#include <string>
#include <vector>

struct SpeciesAnimation {
public:
    std::string id;
    std::string position;
    std::vector<double> size;
    uint32_t requiredLoops;

    SpeciesAnimation(
        std::string id,
        std::string position,
        std::vector<double> size,
        uint32_t requiredLoops
    );
};

struct Species {
public:
    std::string id;
    std::string dragPath;
    std::string movementPath;
    uint32_t zIndex;
    double speed;
    double scale;
    std::vector<SpeciesAnimation> animations;
    std::vector<std::string> capabilities;

    Species(std::string id, double speed, double scale);
};
