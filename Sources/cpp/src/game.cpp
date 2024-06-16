#include "game.h"

Game::Game(double fps) : fps(fps), entities(std::vector<Entity>({})) {}

void Game::update(long timeSinceLastUpdate) {
    for (auto& entity : entities) {
        entity.update(timeSinceLastUpdate);
    }
}

void Game::add(Entity entity) {
    entities.push_back(entity);
}