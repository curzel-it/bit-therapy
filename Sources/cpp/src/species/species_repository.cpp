#include <numeric>
#include <optional>
#include <ranges>

#include "../utils/utils.h"
#include "species_repository.h"
#include "species_parser.h"

SpeciesRepository::SpeciesRepository(const SpeciesParser* parser) : 
    parser(parser),
    speciesById(std::map<std::string, Species>{}) 
{}

void SpeciesRepository::setup(const std::string rootPath) {
    auto paths = listFiles(rootPath, ".json");

    auto allSpecies = compactMap<std::string, Species>(paths, [this](const std::string path) {
        return parser->parseFromFile(path);
    });
    
    speciesById = makeLookup<Species, std::string>(allSpecies, [](const Species species) {
        return species.id;
    });
}

uint32_t SpeciesRepository::numberOfAvailableSpecies() const {
    return speciesById.size();
}

std::vector<std::string> SpeciesRepository::availableSpecies() const {
    auto kv = std::views::keys(speciesById);
    std::vector<std::string> ids{ kv.begin(), kv.end() };
    std::sort(ids.begin(), ids.end()); 
    return ids;
}

std::optional<const Species*> SpeciesRepository::species(std::string speciesId) const {
    if (auto iter = speciesById.find(speciesId); iter != speciesById.end()) {
       return &iter->second;
    }
    return std::nullopt;
}