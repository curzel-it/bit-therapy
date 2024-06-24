#include <gtest/gtest.h>
#include <iostream>
#include <map>
#include <optional>
#include <string>
#include <vector>

#include "../config_tests.h"
#include "../species/species.h"
#include "../species/species_repository.h"
#include "sprites_repository.h"
#include "sprite_set_builder.h"

TEST(SpritesRepositoryTests, CanLoadSpritesForAllSpecies) {
    SpriteSetBuilder builder;
    SpritesRepository spritesRepo(&builder);
    SpeciesParser parser;
    SpeciesRepository speciesRepo(&parser);
    
    spritesRepo.setup(ASSETS_PATH);
    speciesRepo.setup(SPECIES_PATH);

    auto allSpecies = speciesRepo.availableSpecies();    

    for (const std::string& speciesId : allSpecies) {
        auto spriteSet = spritesRepo.sprites(speciesId);
        ASSERT_TRUE(spriteSet.has_value());
        auto numberOfFrames = spriteSet.value()->frontSprite(1.0).numberOfFrames();
        ASSERT_NE(numberOfFrames, 0);
    }
};