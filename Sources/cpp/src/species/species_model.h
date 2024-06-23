#ifndef SPECIES_MODEL_H
#define SPECIES_MODEL_H

#include <string>

struct Species {
public:
    std::string id;
    double speed;
    double scale;

    Species(std::string id, double speed, double scale);
};

#endif