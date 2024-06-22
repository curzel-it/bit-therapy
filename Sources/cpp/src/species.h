#ifndef SPECIES_H
#define SPECIES_H

#include <string>

class Species {
public:
    std::string id;
    double speed;
    double scale;

    Species(
        std::string id,
        double speed,
        double scale
    );
};

#endif
