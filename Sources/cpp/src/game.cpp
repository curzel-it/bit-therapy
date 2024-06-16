#include "game.h"

#include <iostream>

Game::Game(double fps) : fps(fps), entities(std::vector<Entity>({})) {}

void Game::update(long timeSinceLastUpdate) {
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

const int Game::numberOfEntities() {
    std::lock_guard<std::mutex> lock(mtx);
    return entities.size();
}