#ifndef GAME_WINDOW_H
#define GAME_WINDOW_H

#include <QWidget>

class GameWindow {    
private:
    QWidget window;

    void setup();

public:
    explicit GameWindow();
    void show();
};

#endif
