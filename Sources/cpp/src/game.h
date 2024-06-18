#ifndef GAME_H
#define GAME_H

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
    
    void update(long timeSinceLastUpdate);    
    Entity * add(Entity entity);    
    const int numberOfEntities();
    std::vector<RenderedItem> render();
    std::string description();
};

#endif
