#include <QApplication>

#include <chrono>
#include <iostream>
#include <memory>
#include <thread>
#include <boost/program_options.hpp>

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

namespace po = boost::program_options;

void setupGame(Game * game, SpriteSetBuilder& builder, std::string selectedSpecies);
std::thread startGameLoop(Game * game);
po::variables_map parseArgs(int argc, char *argv[]);

int main(int argc, char *argv[]) {
    auto args = parseArgs(argc, argv);
    std::string selectedSpecies = "ape";
    
    if (args.count("species")) {
        selectedSpecies = args["species"].as<std::string>();
    } else {
        std::cout << "No species specified.\n";
    }

    std::cout << "Starting..." << std::endl;

    SpriteSetBuilder builder = SpriteSetBuilder({});    

    Game game(GAME_FPS);
    setupGame(&game, builder, selectedSpecies);    
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

po::variables_map parseArgs(int argc, char *argv[]) {
    po::options_description desc("Allowed options");
    desc.add_options()
        ("help,h", "produce help message")
        ("species", po::value<std::string>(), "enter species name");

    po::variables_map vm;
    po::store(po::parse_command_line(argc, argv, desc), vm);
    po::notify(vm);

    if (vm.count("help")) {
        std::cout << desc << "\n";
    }
    return vm;
}

void setupGame(Game * game, SpriteSetBuilder& builder, std::string selectedSpecies) {
    auto assetPaths = listFiles(ASSETS_PATH, ".png");
    auto spriteSets = builder.spriteSets(assetPaths);
    auto apeSprites = spriteSets[selectedSpecies];

    auto frame = Rect(0.0, 0.0, 50.0, 50.0);

    Species apeSpecies(selectedSpecies, 1.0, 1.0);
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