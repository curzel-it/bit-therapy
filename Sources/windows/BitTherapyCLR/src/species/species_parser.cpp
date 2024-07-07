#include "species_parser.h"

#include <fstream>
#include <iostream>
#include <optional>
#include <sstream>
#include <vector>

#include "species_model.h"

#include "../utils/utils.h"

#include "../../dependencies/nlohmann_json.hpp"

static const std::string SPECIES_ANIMATION_POSITION_FROM_ENTITY_BOTTOM_LEFT = "fromEntityBottomLeft";

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
            json.value("id", "missingno"),
            json.value("speed", 1.0),
            json.value("scale", 1.0)
        );

        species.capabilities = json.value("capabilities", std::vector<std::string>({}));
        species.dragPath = json.value("dragPath", "drag");
        species.movementPath = json.value("movementPath", "walk");
        species.zIndex = json.value("zIndex", 0);

        if (json.contains("animations")) {
            for (const auto& anim : json.at("animations")) {
                species.animations.emplace_back(
                    anim.value("id", "undefined"),
                    anim.value("position", SPECIES_ANIMATION_POSITION_FROM_ENTITY_BOTTOM_LEFT),
                    anim.value("size", std::vector({1.0, 1.0})),
                    anim.value("requiredLoops", 1)
                );
            }
        }

        return species;
    } catch (const std::exception& e) {
        std::cerr << "Failed to parse species: " << e.what() << std::endl;
        return std::nullopt;
    }
}
