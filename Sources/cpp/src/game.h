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
    
    void update(long time_since_last_update);
};

#endif
