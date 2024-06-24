#include <iostream>
#include <map>
#include <numeric>
#include <optional>
#include <ranges>
#include <string>

#include "../utils/utils.h"
#include "sprite.h"
#include "sprite_set.h"
#include "sprite_set_builder.h"
#include "sprites_repository.h"

SpritesRepository::SpritesRepository(const SpriteSetBuilder* builder) : 
    builder(builder),
    spriteSets(std::map<std::string, SpriteSet>{})
{}

void SpritesRepository::setup(const std::string rootPath) {
    auto paths = listFiles(rootPath, ".png");
    spriteSets = builder->spriteSets(paths);
}

std::optional<const SpriteSet*> SpritesRepository::sprites(std::string speciesId) const {
    if (auto iter = spriteSets.find(speciesId); iter != spriteSets.end()) {
        return &iter->second;
    }
    return std::nullopt;
}