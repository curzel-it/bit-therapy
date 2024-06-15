#ifndef SPRITE_SET_BUILDER_H
#define SPRITE_SET_BUILDER_H

#include "sprite_set.h"

#include <map>
#include <optional>
#include <set>
#include <string>
#include <vector>

class SpriteSetBuilder {
public:
    virtual ~SpriteSetBuilder() = default;
    virtual std::map<std::string, SpriteSet> spriteSets(const std::vector<std::string>& paths) const = 0;
};

#endif