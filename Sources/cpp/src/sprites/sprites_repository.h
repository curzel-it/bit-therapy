#pragma once

#include <map>
#include <optional>
#include <string>
#include <vector>

#include "sprite.h"
#include "sprite_set.h"
#include "sprite_set_builder.h"

class SpritesRepository {
    const SpriteSetBuilder* builder;
    std::map<std::string, SpriteSet> spriteSets;

public:
    SpritesRepository(const SpriteSetBuilder* builder);

    void setup(const std::string rootPath);
    
    std::optional<const SpriteSet*> sprites(std::string speciesId) const;
};