#include "../utils/utils.h"
#include "sprite_set.h"
#include "sprite_set_builder.h"

#include <map>
#include <optional>
#include <regex>
#include <set>
#include <string>
#include <vector>
#include <numeric>
#include <execution>
#include <algorithm>

std::map<std::string, SpriteSet> SpriteSetBuilder::spriteSets(const std::vector<std::string>& paths) const {
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

void sortSpriteFrames(std::vector<SpriteFrame>& frames) {
    std::sort(frames.begin(), frames.end(),
        [](const SpriteFrame& a, const SpriteFrame& b) {
            if (a.species < b.species) return true;
            if (a.species > b.species) return false;
            if (a.animation < b.animation) return true;
            if (a.animation > b.animation) return false;
            return a.index < b.index;
        }
    );
}

std::map<std::string, std::vector<SpriteFrame>> SpriteSetBuilder::aggregateFramesBySpecies(const std::vector<SpriteFrame>& frames) const {
    return aggregate<SpriteFrame, std::string>(frames, [](const SpriteFrame& frame) { return frame.species; });
}

std::optional<SpriteSet> SpriteSetBuilder::spriteSet(const std::vector<SpriteFrame>& frames) const {
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

std::vector<SpriteFrame> SpriteSetBuilder::spriteFramesFromPaths(const std::vector<std::string>& paths) const {
    std::vector<SpriteFrame> frames;
    frames.reserve(paths.size());

    for (const auto& path : paths) {
        if (auto optionalFrame = spriteFrameFromPath(path)) {
            frames.push_back(*optionalFrame);
        }
    }

    sortSpriteFrames(frames);
    return frames;
}

std::optional<SpriteFrame> SpriteSetBuilder::spriteFrameFromPath(const std::string& path) const {
    std::regex re("^(.+?)_([a-zA-Z]+)-([0-9]+)$");
    std::smatch matches;

    auto name = fileName(
        replace(
            replace(
                replace(path, "_walk-", "_movement-"), 
                "_fly-", "_movement-"
            ), 
            "_move-", "_movement-"
        )
    );

    if (std::regex_match(name, matches, re)) {
        std::string species = matches[1];
        std::string animationName = matches[2];
        uint32_t index = parseInt(matches[3]).value_or(-1);

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