#include "game.h"

Game::Game(double fps) : fps(fps), entities(std::vector<Entity>({})) {}

void Game::update(long time_since_last_update) {
    for (auto& entity : entities) {
        entity.update(time_since_last_update);
    }
}