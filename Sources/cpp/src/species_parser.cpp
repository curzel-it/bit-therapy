#include "species_parser.h"

#include <fstream>
#include <iostream>
#include <optional>
#include <sstream>
#include <vector>

#include "species.h"
#include "vector_utils.h"

std::vector<Species> SpeciesParser::parseFromFiles(const std::vector<std::string> paths) {
    return compactMap<std::string, Species>(paths, [this](const std::string path) {
        return parseFromFile(path);
    });
}

std::optional<Species> SpeciesParser::parseFromFile(const std::string& filePath) {
    std::ifstream file(filePath);
    if (!file.is_open()) {
        return std::nullopt;
    }
    std::stringstream buffer;
    buffer << file.rdbuf();
    return parse(buffer.str()); 
}

std::optional<Species> SpeciesParser::parse(const std::string& jsonString) {
    try {
        auto json = nlohmann::json::parse(jsonString);
        Species species(
            json.at("id").get<std::string>(),
            json.at("speed").get<double>(),
            json.value<double>("scale", 1.0)
        );
        return species;
    } catch (const std::exception& e) {
        std::cerr << "Failed to parse species: " << e.what() << std::endl;
        return std::nullopt;
    }
}
