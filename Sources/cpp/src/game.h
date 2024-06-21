#ifndef GAME_H
#define GAME_H

#include <chrono>
#include <format>
#include <mutex>
#include <vector>

#include "entity.h"

struct RenderedItem {
    std::string spritePath;
    Rect frame;

    RenderedItem(std::string spritePath, Rect frame);
};

class Game {    
private:
    std::mutex mtx;
    std::vector<Entity> entities;

public:
    double fps;

    Game(double fps);
    
    void update(std::chrono::milliseconds timeSinceLastUpdate);    
    Entity * add(Entity entity);    
    const uint32_t numberOfEntities();
    std::vector<RenderedItem> render();
    std::string description();
};

#endif
