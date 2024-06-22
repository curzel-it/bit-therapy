#ifndef SPECIES_PARSER_IMPL_H
#define SPECIES_PARSER_IMPL_H

#include <optional>
#include <string>
#include "nlohmann/json.hpp"
#include "species.h"
#include "species_parser.h"

class SpeciesParser {
public:
    std::vector<Species> parseFromFiles(const std::vector<std::string> paths);
    std::optional<Species> parseFromFile(const std::string& filePath);
    std::optional<Species> parse(const std::string& jsonString);
};

#endif
