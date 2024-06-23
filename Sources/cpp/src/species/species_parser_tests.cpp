#include "species_parser.h"

#include <gtest/gtest.h>
#include <string>
#include <vector>

TEST(SpeciesParserTests, ReturnsNullWithEmptyString) {
    SpeciesParser parser;
    std::optional<Species> result = parser.parse("");
    EXPECT_FALSE(result.has_value()); 
}

TEST(SpeciesParserTests, ReturnsNullWithMalformedJson) {
    SpeciesParser parser;
    std::string malformedJson = "{id:\"Tiger\", \"speed\":35.5, \"scale\":1.2";
    std::optional<Species> result = parser.parse(malformedJson);
    EXPECT_FALSE(result.has_value()); 
}

TEST(SpeciesParserTests, CanParseSpeciesFromString) {
    SpeciesParser parser;
    std::string correctJson = "{\"id\":\"Tiger\", \"speed\":35.5, \"scale\":1.2}";
    std::optional<Species> result = parser.parse(correctJson);
    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->id, "Tiger");
    EXPECT_DOUBLE_EQ(result->speed, 35.5);
    EXPECT_DOUBLE_EQ(result->scale, 1.2);
}

TEST(SpeciesParserTests, CanParseSpeciesFromFilePathWithoutScale) {
    SpeciesParser parser;
    auto path = "/Users/curzel/dev/bit-therapy/Species/panda.json";
    auto result = parser.parseFromFile(path);

    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->id, "panda");
    EXPECT_DOUBLE_EQ(result->speed, 0.8);
    EXPECT_DOUBLE_EQ(result->scale, 1.0);
}

TEST(SpeciesParserTests, CanParseSpeciesFromFilePathWithScale) {
    SpeciesParser parser;
    auto path = "/Users/curzel/dev/bit-therapy/Species/cayman718.json";
    auto result = parser.parseFromFile(path);

    ASSERT_TRUE(result.has_value());
    EXPECT_EQ(result->id, "cayman718");
    EXPECT_DOUBLE_EQ(result->speed, 1.7);
    EXPECT_DOUBLE_EQ(result->scale, 1.5);
}