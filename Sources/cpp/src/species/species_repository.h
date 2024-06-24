#ifndef SPECIES_REPOSITORY_H
#define SPECIES_REPOSITORY_H

#include <map>
#include <optional>
#include <string>
#include <vector>

#include "species_model.h"
#include "species_parser.h"

class SpeciesRepository {
    const SpeciesParser* parser;
    std::map<std::string, Species> speciesById;

public:
    SpeciesRepository(const SpeciesParser* parser);

    void setup(const std::string rootPath);
    
    uint32_t numberOfAvailableSpecies() const;
    std::optional<const Species*> species(std::string speciesId) const;
    std::vector<std::string> availableSpecies() const;
};

#endif
