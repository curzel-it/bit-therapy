#include <QApplication>
#include <iostream>
#include <thread>
#include <chrono>

#include "app_window.h"
#include "game.h"
#include "game_window.h"
#include "geometry.h"
#include "entity.h"
#include "file_utils.h"
#include "sprite_set_builder.h"
#include "sprite_set_builder_impl.h"

const double GAME_FPS = 30.0;

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);    

    AppWindow appWindow;
    appWindow.show();

    GameWindow gameWindow;
    gameWindow.show();


    Game game(GAME_FPS);

    auto assetPaths = listFiles("/Users/curzel/dev/bit-therapy/PetsAssets", ".png");

    SpriteSetBuilderImpl builderImpl = SpriteSetBuilderImpl({});
    SpriteSetBuilder& builder = builderImpl;
    auto spriteSets = builder.spriteSets(assetPaths);
    auto apeSprites = spriteSets["ape"];

    Entity ape(GAME_FPS, "ape", apeSprites);
    game.add(ape);

    std::thread gameThread([&]() {
        bool gameIsRunning = true;
        auto frameDuration = std::chrono::milliseconds(int(1000 / GAME_FPS));
        auto frameDurationMs = std::chrono::duration_cast<std::chrono::milliseconds>(frameDuration).count();
        
        while (gameIsRunning) { 
            auto frameStart = std::chrono::steady_clock::now();
            std::cout << "Updating!" << "\n";
            game.update(frameDurationMs);

            auto frameEnd = std::chrono::steady_clock::now();
            auto elapsedTime = std::chrono::duration_cast<std::chrono::milliseconds>(frameEnd - frameStart);
            
            auto sleepDuration = frameDuration - elapsedTime;
            if (sleepDuration > std::chrono::milliseconds(0)) {
                std::this_thread::sleep_for(sleepDuration);
            }
        }
    });

    // Assume code here to link the game to the UI and launch the app
    // When exiting, ensure to join the thread
    // gameThread.join();

    return app.exec();
}