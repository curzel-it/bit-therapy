#include <QApplication>

#include "app_window.h"
#include "game_window.h"
#include "game.h"
#include "geometry.h"
#include "file_utils.h"
#include "sprite_set_builder.h"
#include "sprite_set_builder_impl.h"

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);    

    AppWindow appWindow;
    appWindow.show();

    GameWindow gameWindow;
    gameWindow.show();

    return app.exec();
}