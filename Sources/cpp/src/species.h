#ifndef SPECIES_H
#define SPECIES_H

#include <string>

class Species {
public:
    std::string id;
    double speed;
    double size;

    Species(
        std::string id,
        double speed,
        double size
    );
};

#endif
