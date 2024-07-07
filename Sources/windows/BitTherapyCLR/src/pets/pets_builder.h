#pragma once

#include <optional>
#include <string>

#include "../game/game.h"
#include "../sprites/sprites.h"

class PetsBuilder {
private:
    uint32_t nextId;
    const SpeciesRepository* speciesRepo;
    const SpritesRepository* spritesRepo;
    const double animationFps;
    const double baseSize;
    const double scaleMultiplier;
    const double speedMultiplier;

public:
    PetsBuilder(
        const SpeciesRepository* speciesRepo, 
        const SpritesRepository* spritesRepo,
        const double animationFps,
        const double baseSize,
        const double scaleMultiplier,
        const double speedMultiplier
    );

    std::optional<Entity*> build(const std::string& species, const Rect& gameBounds);
};