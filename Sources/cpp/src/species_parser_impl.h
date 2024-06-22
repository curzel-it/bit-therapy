#ifndef SPECIES_PARSER_IMPL_H
#define SPECIES_PARSER_IMPL_H

#include <optional>
#include <string>
#include "nlohmann/json.hpp"
#include "species.h"
#include "species_parser.h"

class SpeciesParserImpl : public SpeciesParser {
public:
    std::optional<Species> parseFromFile(const std::string& filePath) override;
    std::optional<Species> parse(const std::string& jsonString);
};

#endif
