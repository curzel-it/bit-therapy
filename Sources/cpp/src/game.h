#ifndef GAME_H
#define GAME_H

#include <vector>

#include "entity.h"

class Game {    
private:
    double fps;
    std::vector<Entity> entities;

public:
    Game(double fps);
    
    void update(long timeSinceLastUpdate);

    void add(Entity entity);
};

#endif
