#include "pets_builder.h"

#include <iostream>

#include "../capabilities/capabilities.h"

PetsBuilder::PetsBuilder(
    const SpeciesRepository* speciesRepo, 
    const SpritesRepository* spritesRepo,
    const double animationFps,
    const double baseSize,
    const double scaleMultiplier,
    const double speedMultiplier
) : 
    nextId(1000),
    speciesRepo(speciesRepo),
    spritesRepo(spritesRepo),
    animationFps(animationFps),
    baseSize(baseSize),
    scaleMultiplier(scaleMultiplier),
    speedMultiplier(speedMultiplier)
{}

std::optional<Entity*> PetsBuilder::build(const std::string& speciesId, const Rect& gameBounds) {
    auto speciesOpt = speciesRepo->species(speciesId);
    auto spritesOpt = spritesRepo->sprites(speciesId);

    if (!speciesOpt.has_value() || !spritesOpt.has_value()) {
        std::cerr << "Species `" << speciesId << "` not found!" << std::endl;
        return std::nullopt;
    }
    auto species = speciesOpt.value();
    auto sprites = spritesOpt.value();  

    auto frame = Rect(
        rand() % (int)gameBounds.w,
        1.0, 
        baseSize * species->scale * scaleMultiplier, 
        baseSize * species->scale * scaleMultiplier
    );

    Entity* entity = new Entity(++nextId, animationFps, speedMultiplier, species, sprites, frame);

    bool isWallCrawler = std::find(species->capabilities.begin(), species->capabilities.end(), "WallCrawler") != species->capabilities.end();

    entity->addCapability(std::make_shared<RandomAnimations>());
    entity->addCapability(std::make_shared<LinearMovement>());
    entity->addCapability(std::make_shared<Gravity>(gameBounds.h));

    if (isWallCrawler) {
        entity->addCapability(std::make_shared<WallCrawler>(gameBounds));
    } else {
        entity->addCapability(std::make_shared<BounceWhenLateralBoundIsHit>(0, gameBounds.w));
    }

    return entity;
}