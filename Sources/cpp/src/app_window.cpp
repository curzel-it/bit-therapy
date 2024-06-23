#include "app_window.h"
#include "game/game.h"
#include "utils/utils.h"
#include "sprites/sprites.h"

#include <QWidget>
#include <QLabel>
#include <QVBoxLayout>
#include <QString>
#include <QScrollArea>

AppWindow::AppWindow(QWidget *parent): QWidget(parent) {
    buildUi();
}

void AppWindow::buildUi() {
    Vector2d vector1(3.5, 2.5);
    Vector2d vector2(1.5, 4.0);
    Vector2d sum = vector1 + vector2;
    
    auto paths = listFiles("/Users/curzel/dev/bit-therapy/PetsAssets", ".png");
    
    SpriteSetBuilder builder({});
    auto spriteSets = builder.spriteSets(paths);

    QVBoxLayout *layout = new QVBoxLayout();

    QLabel *label = new QLabel(QString("Sum of vectors: (%1, %2)").arg(sum.x).arg(sum.y));
    layout->addWidget(label);

    QLabel *fileCountLabel = new QLabel(QString("Found %1 PNGs").arg(paths.size()));
    layout->addWidget(fileCountLabel);

    QLabel *spriteSetCountLabel = new QLabel(QString("Found %1 sprite sets").arg(spriteSets.size()));
    layout->addWidget(spriteSetCountLabel);

    QLabel *listLabel = new QLabel("List of PNG Files:");
    layout->addWidget(listLabel);

    QString filesText;
    for (const auto &path : paths) {
        filesText += QString::fromStdString(path) + "\n";
    }

    QLabel *filesLabel = new QLabel(filesText);
    filesLabel->setWordWrap(true);

    QScrollArea *scrollArea = new QScrollArea;
    scrollArea->setWidgetResizable(true);
    scrollArea->setWidget(filesLabel);

    layout->addWidget(scrollArea);

    setLayout(layout);
    setWindowTitle("Bit Therapy");
}
