#ifndef GAME_WINDOW_H
#define GAME_WINDOW_H

#include "game.h"

#include <QWidget>

class GameWindow {    
private:
    QWidget window;
    Game * game;

    void setup();

public:
    GameWindow(Game * game);
    void show();
};

#endif
