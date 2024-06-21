#include "game.h"

#include <chrono>
#include <iostream>
#include <sstream>

#include "geometry.h"
#include "string_utils.h"

RenderedItem::RenderedItem(std::string spritePath, Rect frame) : spritePath(spritePath), frame(frame) {}

Game::Game(double fps) : fps(fps), entities(std::vector<Entity>({})) {}

void Game::update(std::chrono::milliseconds timeSinceLastUpdate) {
    std::lock_guard<std::mutex> lock(mtx);
    for (auto& entity : entities) {
        entity.update(timeSinceLastUpdate);
    }
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

    ss << entities.size() << " entities:" << std::endl;

    for (const auto& entity : entities) {
        auto s = entity.description();
        trim(s);
        ss << "  - " << s << " @ " << &entity << std::endl;
    }
    return ss.str();
}