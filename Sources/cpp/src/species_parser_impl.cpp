#include "species_parser_impl.h"

#include <iostream>
#include <fstream>
#include <sstream>

std::optional<Species> SpeciesParserImpl::parseFromFile(const std::string& filePath) {
    std::ifstream file(filePath);
    if (!file.is_open()) {
        return std::nullopt;
    }

    std::stringstream buffer;
    buffer << file.rdbuf();
    return parse(buffer.str()); 
}

std::optional<Species> SpeciesParserImpl::parse(const std::string& jsonString) {
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
