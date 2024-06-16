#include "file_utils.h"
#include "sprite_set.h"
#include "sprite_set_builder_impl.h"
#include "string_utils.h"
#include "vector_utils.h"

#include <map>
#include <optional>
#include <regex>
#include <set>
#include <string>
#include <vector>
#include <numeric>
#include <execution>
#include <algorithm>

std::map<std::string, std::vector<SpriteFrame>> SpriteSetBuilderImpl::aggregateFramesBySpecies(const std::vector<SpriteFrame>& frames) const {
    return aggregate<SpriteFrame, std::string>(frames, [](const SpriteFrame& frame) { return frame.species; });
}

std::map<std::string, SpriteSet> SpriteSetBuilderImpl::spriteSets(const std::vector<std::string>& paths) const {
    auto frames = spriteFramesFromPaths(paths);
    auto framesBySpecies = aggregateFramesBySpecies(frames);

    std::map<std::string, SpriteSet> setsBySpecies;

    for (const auto& [species, frames] : framesBySpecies) {
        std::optional<SpriteSet> set = spriteSet(frames);
        if (set.has_value()) {
            setsBySpecies[species] = *set;
        }
    }
    return setsBySpecies;
}

std::optional<SpriteSet> SpriteSetBuilderImpl::spriteSet(const std::vector<SpriteFrame>& frames) const {
    auto framesByAnimation = aggregateMap<SpriteFrame, std::string, std::string>(
        frames, 
        [](const SpriteFrame& frame) { return frame.animation; }, 
        [](const SpriteFrame& frame) { return frame.path; }
    );

    return SpriteSet(
        framesByAnimation[SPRITE_NAME_MOVEMENT],
        framesByAnimation[SPRITE_NAME_FALL],
        framesByAnimation[SPRITE_NAME_FRONT],
        framesByAnimation
    );
}

std::vector<SpriteFrame> SpriteSetBuilderImpl::spriteFramesFromPaths(const std::vector<std::string>& paths) const {
    std::vector<SpriteFrame> frames;
    frames.reserve(paths.size());

    for (const auto& path : paths) {
        if (auto optionalFrame = spriteFrameFromPath(path)) {
            frames.push_back(*optionalFrame);
        }
    }
    return frames;
}

std::optional<SpriteFrame> SpriteSetBuilderImpl::spriteFrameFromPath(const std::string& path) const {
    std::regex re("^(.+?)_([a-zA-Z]+)-([0-9]+)$");
    std::smatch matches;

    auto name = fileName(
        replace(
            replace(path, "_walk.", "_movement."), 
            "_fly.", "_movement."
        )
    );

    if (std::regex_match(name, matches, re)) {
        std::string species = matches[1];
        std::string animationName = matches[2];
        int index = parseInt(matches[3]).value_or(-1);

        if (index >= 0) {
            return std::make_optional<SpriteFrame>({
                path, species, animationName, index
            });
        }
    } 
    return {};
}

bool SpriteFrame::operator==(const SpriteFrame& other) const {
    return path == other.path && species == other.species && animation == other.animation;
}