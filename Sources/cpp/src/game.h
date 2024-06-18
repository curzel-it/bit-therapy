#ifndef GAME_H
#define GAME_H

#include <format>
#include <mutex>
#include <vector>

#include "entity.h"

class Game {    
private:
    std::mutex mtx;

public:
    double fps;
    std::vector<Entity> entities;

    Game(double fps);
    
    void update(long timeSinceLastUpdate);    
    Entity * add(Entity entity);    
    const int numberOfEntities();
    std::string description() const;
};

#endif
