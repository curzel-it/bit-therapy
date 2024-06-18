#ifndef GAME_WINDOW_H
#define GAME_WINDOW_H

#include "game.h"
#include "geometry.h"

#include <QGraphicsScene>
#include <QLabel>
#include <QWidget>

class GameWindow : public QWidget {    
    Q_OBJECT

private:
    QGraphicsScene *scene;
    Game *game;
    Rect frame;

    void setupTimer();
    void buildUi();

public:
    GameWindow(QWidget *parent = nullptr);
    void setup(Game *game, Rect frame);
    void updateUi();
};

#endif
