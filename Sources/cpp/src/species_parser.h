#ifndef SPECIES_PARSER_H
#define SPECIES_PARSER_H

#include <optional>
#include <string>
#include "nlohmann/json.hpp"
#include "species.h"

class SpeciesParser {
public:
    virtual std::optional<Species> parseFromFile(const std::string& filePath) = 0;
};

#endif
