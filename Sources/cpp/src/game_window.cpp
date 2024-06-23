#include <QGraphicsPixmapitem>
#include <QGraphicsView>
#include <QImage>
#include <QLabel>
#include <QPainter>
#include <QScrollArea>
#include <QString>
#include <QTimer>
#include <QTime>
#include <QVBoxLayout>
#include <QWidget>

#include <format>

#include "game/game.h"
#include "game_window.h"
#include "utils/utils.h"
#include "sprites/sprites.h"

GameWindow::GameWindow(QWidget *parent): QWidget(parent) {}

void GameWindow::setup(Game *game, Rect frame) {
    this->game = game;
    this->frame = frame;
    buildUi();
    setupTimer();
}

void GameWindow::setupTimer() {
    QTimer *timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, &GameWindow::updateUi);
    timer->start(2 * 1000.0 / game->fps);
}

void GameWindow::buildUi() {
    scene = new QGraphicsScene();
    scene->setSceneRect(frame.x, frame.y, frame.w, frame.h);
    QGraphicsView *sceneView = new QGraphicsView(scene);
    sceneView->setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    sceneView->setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    sceneView->setStyleSheet("background: transparent");
    
    QVBoxLayout *layout = new QVBoxLayout();
    layout->setSpacing(0);
    layout->setContentsMargins(0, 0, 0, 0);
    layout->addWidget(sceneView);
    setLayout(layout);

    setGeometry(frame.x, frame.y, frame.w, frame.h);
    setWindowFlags(Qt::FramelessWindowHint | Qt::WindowStaysOnTopHint);
    setAttribute(Qt::WA_TranslucentBackground);
    setWindowTitle("Game Window");
}

void GameWindow::updateUi() {
    scene->clear();

    QString description = QString::fromStdString(game->description());
    QGraphicsTextItem *gameStateText = scene->addText(description);
    gameStateText->setDefaultTextColor(Qt::white);
    gameStateText->setFont(QFont("Courier New", 16, QFont::DemiBold));
    gameStateText->setPos(0, 50);

    for (const auto& item : game->render()) {
        auto path = QString::fromStdString(item.spritePath);        
        QPixmap pixmap(path);
        QPixmap scaledPixmap = pixmap.scaled(
            item.frame.w, 
            item.frame.h, 
            Qt::KeepAspectRatio, 
            Qt::FastTransformation
        );
        QGraphicsPixmapItem *pixmapItem = new QGraphicsPixmapItem(scaledPixmap);
        pixmapItem->setPos(item.frame.x, item.frame.h);
        scene->addItem(pixmapItem);
    }
}
