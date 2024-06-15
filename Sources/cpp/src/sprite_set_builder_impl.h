#ifndef SPRITE_SET_BUILDER_IMPL_H
#define SPRITE_SET_BUILDER_IMPL_H

#include "sprite_set.h"
#include "sprite_set_builder.h"

#include <map>
#include <optional>
#include <set>
#include <string>
#include <vector>

struct SpriteFrame {
    std::string path;
    std::string species;
    std::string animation;
    int index;

    bool operator==(const SpriteFrame& other) const;
};

class SpriteSetBuilderImpl : public SpriteSetBuilder {
public:
    std::map<std::string, std::vector<SpriteFrame>> aggregateFramesBySpecies(const std::vector<SpriteFrame>& frames) const;
    std::map<std::string, SpriteSet> spriteSets(const std::vector<std::string>& paths) const;
    std::optional<SpriteSet> spriteSet(const std::vector<SpriteFrame>& frames) const;
    std::vector<SpriteFrame> spriteFramesFromPaths(const std::vector<std::string>& paths) const;
    std::optional<SpriteFrame> spriteFrameFromPath(const std::string& path) const;
};

#endif 
