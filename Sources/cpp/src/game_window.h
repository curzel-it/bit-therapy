#ifndef GAME_WINDOW_H
#define GAME_WINDOW_H

#include "game.h"

#include <QGraphicsScene>
#include <QLabel>
#include <QWidget>

class GameWindow : public QWidget {    
    Q_OBJECT

private:
    QGraphicsScene *scene;
    Game *game;

    void setupTimer();
    void buildUi();

public:
    GameWindow(QWidget *parent = nullptr);
    void setup(Game *game);
    void updateUi();
};

#endif
