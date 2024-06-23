#include "game.h"

#include <chrono>
#include <iostream>
#include <sstream>

#include "geometry.h"
#include "../utils/utils.h"

RenderedItem::RenderedItem(std::string spritePath, Rect frame) : 
    spritePath(spritePath), 
    frame(frame) 
{}

Game::Game(
    const SpritesRepository* spritesRepo,
    const SpeciesRepository* speciesRepo,
    std::string screenName,
    double gameFps, 
    double animationFps, 
    double baseEntitySize
) : 
    spritesRepo(spritesRepo), 
    speciesRepo(speciesRepo), 
    screenName(screenName),
    gameFps(gameFps), 
    animationFps(animationFps), 
    baseEntitySize(baseEntitySize), 
    entities(std::vector<Entity>({})) 
{}

void Game::update(std::chrono::milliseconds timeSinceLastUpdate) {
    std::lock_guard<std::mutex> lock(mtx);
    for (auto& entity : entities) {
        entity.update(timeSinceLastUpdate);
    }
}

std::vector<Entity *> Game::addEntities(const std::vector<std::string>& species) {
    return compactMap<std::string, Entity*>(species, [this](const std::string aSpecies) {
        return addEntity(aSpecies);
    });
}

std::optional<Entity *> Game::addEntity(const std::string& speciesId) {
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
        baseEntitySize * species->scale, 
        baseEntitySize * species->scale
    );

    Entity entity(animationFps, 50.0, 1.0, species, sprites, frame);
    return add(entity);
}

Entity * Game::add(Entity entity) {
    std::lock_guard<std::mutex> lock(mtx);
    entities.push_back(entity);
    return &entities.back();
}

const uint32_t Game::numberOfEntities() {
    std::lock_guard<std::mutex> lock(mtx);
    return entities.size();
}

std::vector<RenderedItem> Game::render() {
    std::lock_guard<std::mutex> lock(mtx);
    std::vector<RenderedItem> renderedItems({});
    
    for (const auto& entity : entities) {
        auto item = RenderedItem(entity.currentSpriteFrame(), entity.frame);
        renderedItems.push_back(item);
    }
    return renderedItems;
}

std::string Game::description() {
    std::lock_guard<std::mutex> lock(mtx);
    std::stringstream ss; 

    ss << "Game @" << this << std::endl;
    ss << "  Running on " << screenName << std::endl;
    ss << "  Entities (" << entities.size() << "):" << std::endl;

    for (const auto& entity : entities) {
        ss << "    - " << entity.description() << " @ " << &entity << std::endl;
    }
    return ss.str();
}