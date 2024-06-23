#include <QApplication>

#include <chrono>
#include <iostream>
#include <memory>
#include <thread>

#include "app_window.h"
#include "game/game.h"
#include "game_window.h"

#include "species/species.h"
#include "sprites/sprites.h"
#include "utils/utils.h"

const double GAME_FPS = 30.0;
const double ANIMATIONS_FPS = 10.0;
const std::string SPECIES_PATH = "/Users/curzel/dev/bit-therapy/Species";
const std::string ASSETS_PATH = "/Users/curzel/dev/bit-therapy/PetsAssets";

void setupGame(Game * game, SpriteSetBuilder& builder);
std::thread startGameLoop(Game * game);

int main(int argc, char *argv[]) {
    std::cout << "Starting..." << std::endl;

    SpriteSetBuilder builder = SpriteSetBuilder({});    

    Game game(GAME_FPS);
    setupGame(&game, builder);    
    auto gameLoop = startGameLoop(&game);
    // gameLoop.join();

    QApplication app(argc, argv);    

    Rect frame(0, 0, 1920, 1080);

    GameWindow gameWindow;
    gameWindow.setup(&game, frame);
    gameWindow.show();

    // AppWindow appWindow;
    // appWindow.show();

    return app.exec();
}

void setupGame(Game * game, SpriteSetBuilder& builder) {
    auto assetPaths = listFiles(ASSETS_PATH, ".png");
    auto spriteSets = builder.spriteSets(assetPaths);
    auto apeSprites = spriteSets["ape"];

    auto frame = Rect(0.0, 0.0, 50.0, 50.0);

    Species apeSpecies("ape", 1.0, 1.0);
    Entity ape(ANIMATIONS_FPS, 50.0, 1.0, apeSpecies, apeSprites, frame);

    game->add(ape);
}

std::thread startGameLoop(Game * game) {
    return std::thread([game]() {
        bool gameIsRunning = true;
        auto frameDuration = std::chrono::milliseconds(uint32_t(1000 / GAME_FPS));
        
        while (gameIsRunning) { 
            auto frameStart = std::chrono::steady_clock::now();
            game->update(frameDuration);
            auto frameEnd = std::chrono::steady_clock::now();
            auto elapsedTime = std::chrono::duration_cast<std::chrono::milliseconds>(frameEnd - frameStart);
            
            auto sleepDuration = frameDuration - elapsedTime;
            if (sleepDuration > std::chrono::milliseconds(0)) {
                std::this_thread::sleep_for(sleepDuration);
            }
        }
    });
}