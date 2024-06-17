#include <QWidget>
#include <QLabel>
#include <QVBoxLayout>
#include <QString>
#include <QScrollArea>

#include <format>

#include "game.h"
#include "game_window.h"
#include "geometry.h"
#include "file_utils.h"
#include "sprite_set_builder.h"
#include "sprite_set_builder_impl.h"

GameWindow::GameWindow(Game * game): game(game) {
    setup();
}

void GameWindow::show() {
    window.show();
}

void GameWindow::setup() {
    QVBoxLayout *layout = new QVBoxLayout();

    QLabel *label = new QLabel(QString::fromStdString(game->description()));
    layout->addWidget(label);

    window.setLayout(layout);
    
    window.setWindowFlags(Qt::FramelessWindowHint | Qt::WindowStaysOnTopHint);
    window.setAttribute(Qt::WA_TranslucentBackground);
    window.setWindowTitle("Game Window");
}
