#include <QApplication>
#include <QWidget>
#include <QLabel>
#include <QVBoxLayout>
#include <QString>
#include <QScrollArea>

#include "geometry.h"
#include "file_utils.h"
#include "sprite_set_builder.h"
#include "sprite_set_builder_impl.h"

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    Vector2d vector1(3.5, 2.5);
    Vector2d vector2(1.5, 4.0);
    Vector2d sum = vector1 + vector2;
    
    auto paths = listFiles("/Users/curzel/dev/bit-therapy/PetsAssets", ".png");
    
    SpriteSetBuilderImpl builderImpl = SpriteSetBuilderImpl({});
    SpriteSetBuilder& builder = builderImpl;
    auto spriteSets = builder.spriteSets(paths);

    QWidget window;
    window.setWindowTitle("Qt GUI with Vector and PNG Information");
    
    QVBoxLayout *layout = new QVBoxLayout;

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

    window.setLayout(layout);
    window.show();

    return app.exec();
}