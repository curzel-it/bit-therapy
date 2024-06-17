#include "game.h"

#include <sstream>

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

std::string Game::description() const {
    std::stringstream ss; 

    ss << entities.size() << " entities:" << std::endl;

    for (const auto& entity : entities) {
        auto s = entity.description();
        s.erase(std::remove_if(s.begin(), s.end(), ::isspace), s.end());
        ss << "  - " << s << " @ " << &entity << std::endl;
    }

    return ss.str();
}