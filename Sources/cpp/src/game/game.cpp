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
    entities(std::vector<Entity*>({})) 
{}

void Game::update(std::chrono::milliseconds timeSinceLastUpdate) {
    std::lock_guard<std::mutex> lock(mtx);
    for (auto& entity : entities) {
        entity->update(timeSinceLastUpdate);
    }
}

void Game::addEntities(const std::vector<Entity*> entities) {
    for (Entity* entity : entities) {
        addEntity(entity);
    }
}

void Game::addEntity(Entity* entity) {
    std::lock_guard<std::mutex> lock(mtx);
    entities.push_back(entity);
}

const uint32_t Game::numberOfEntities() {
    std::lock_guard<std::mutex> lock(mtx);
    return entities.size();
}

std::vector<RenderedItem> Game::render() {
    std::lock_guard<std::mutex> lock(mtx);
    std::vector<RenderedItem> renderedItems({});
    
    for (const auto& entity : entities) {
        auto item = RenderedItem(entity->currentSpriteFrame(), entity->frame);
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
        ss << "    - " << entity->description() << " @ " << &entity << std::endl;
    }
    return ss.str();
}