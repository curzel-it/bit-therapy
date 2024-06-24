#include "pets_builder.h"

#include <iostream>

#include "../capabilities/capabilities.h"

PetsBuilder::PetsBuilder(
    const SpeciesRepository* speciesRepo, 
    const SpritesRepository* spritesRepo,
    const double animationFps,
    const double baseSize
) : 
    speciesRepo(speciesRepo),
    spritesRepo(spritesRepo),
    animationFps(animationFps),
    baseSize(baseSize)
{}

std::optional<Entity*> PetsBuilder::build(const std::string& speciesId) const {
    auto speciesOpt = speciesRepo->species(speciesId);
    auto spritesOpt = spritesRepo->sprites(speciesId);

    if (!speciesOpt.has_value() || !spritesOpt.has_value()) {
        std::cerr << "Species `" << speciesId << "` not found!" << std::endl;
        return std::nullopt;
    }
    auto species = speciesOpt.value();
    auto sprites = spritesOpt.value();  

    auto frame = Rect(
        0.0, 0.0, 
        baseSize * species->scale, 
        baseSize * species->scale
    );

    Entity* entity = new Entity(animationFps, 50.0, 1.0, species, sprites, frame);
    entity->addCapability(std::make_shared<LinearMovement>());
    entity->addCapability(std::make_shared<Gravity>());

    return entity;
}