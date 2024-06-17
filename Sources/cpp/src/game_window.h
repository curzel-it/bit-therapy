#ifndef GAME_WINDOW_H
#define GAME_WINDOW_H

#include "game.h"

#include <QLabel>
#include <QWidget>

class GameWindow : public QWidget {    
    Q_OBJECT

private:
    QLabel *gameStateLabel;
    Game *game;

    void setupTimer();
    void buildUi();

public:
    GameWindow(QWidget *parent = nullptr);
    void setup(Game *game);
    void updateUi();
};

#endif
