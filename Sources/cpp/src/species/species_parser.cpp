#include "species_parser.h"

#include <fstream>
#include <iostream>
#include <optional>
#include <sstream>
#include <vector>

#include "species_model.h"
#include "../utils/utils.h"

std::optional<Species> SpeciesParser::parseFromFile(const std::string& filePath) const {
    std::ifstream file(filePath);
    if (!file.is_open()) {
        return std::nullopt;
    }
    std::stringstream buffer;
    buffer << file.rdbuf();
    return parse(buffer.str()); 
}

std::optional<Species> SpeciesParser::parse(const std::string& jsonString) const {
    try {
        auto json = nlohmann::json::parse(jsonString);
        Species species(
            json.at("id").get<std::string>(),
            json.at("speed").get<double>(),
            json.value<double>("scale", 1.0)
        );
        return species;
    } catch (const std::exception& e) {
        return std::nullopt;
    }
}
