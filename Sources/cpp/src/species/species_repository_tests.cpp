#include <gtest/gtest.h>
#include <iostream>
#include <optional>
#include <string>
#include <vector>

#include "../config_tests.h"
#include "../utils/utils.h"
#include "species_repository.h"
#include "species_parser.h"

TEST(SpeciesRepositoryTests, CanBeSetupAndLoadAllSpecies) {
    SpeciesParser parser;
    SpeciesRepository repo(&parser);
    repo.setup(SPECIES_PATH);

    auto expectedNumberOfSpecies = listFiles(SPECIES_PATH, ".json").size();    
    ASSERT_EQ(repo.numberOfAvailableSpecies(), expectedNumberOfSpecies);

    ASSERT_TRUE(repo.species("ape").has_value());
    ASSERT_EQ(repo.species("ape").value()->id, "ape");
    ASSERT_TRUE(repo.species("betta").has_value());
    ASSERT_EQ(repo.species("betta").value()->id, "betta");
    ASSERT_TRUE(repo.species("cat_blue").has_value());
    ASSERT_EQ(repo.species("cat_blue").value()->id, "cat_blue");
}
   