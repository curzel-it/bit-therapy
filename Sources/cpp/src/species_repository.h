#ifndef SPECIES_REPOSITORY_H
#define SPECIES_REPOSITORY_H

#include <optional>
#include <string>
#include "species_parser.h"

class SpeciesRepository {
public:
    SpeciesRepository(
        const SpeciesParser& parser,
        const std::string rootPath
    );
};

#endif
