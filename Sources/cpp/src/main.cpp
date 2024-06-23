#include <QApplication>

#include <boost/program_options.hpp>
#include <chrono>
#include <iostream>
#include <memory>
#include <thread>

#include "app_window.h"

#include "game/game.h"
#include "rendering/rendering.h"
#include "species/species.h"
#include "sprites/sprites.h"
#include "utils/utils.h"

namespace po = boost::program_options;

const double GAME_FPS = 30.0;
const double ANIMATIONS_FPS = 10.0;
const double BASE_ENTITY_SIZE = 50.0;
const std::string SPECIES_PATH = "/Users/curzel/dev/bit-therapy/Species";
const std::string ASSETS_PATH = "/Users/curzel/dev/bit-therapy/PetsAssets";

SpriteSetBuilder builder;
SpritesRepository spritesRepo(builder);
SpeciesParser parser;
SpeciesRepository speciesRepo(parser);

po::variables_map parseArgs(int argc, char *argv[]);
std::vector<Screen> screensMatching(po::variables_map args);
std::vector<std::string> selectedSpecies(po::variables_map args);

int main(int argc, char *argv[]) {
    auto args = parseArgs(argc, argv);
    
    QApplication app(argc, argv);    

    auto screens = screensMatching(args);
    auto species = selectedSpecies(args);

    spritesRepo.setup(ASSETS_PATH);
    speciesRepo.setup(SPECIES_PATH);
    
    Game game(&spritesRepo, &speciesRepo, GAME_FPS, ANIMATIONS_FPS, BASE_ENTITY_SIZE);
    game.addEntities(species);
    auto gameLoop = startGameLoop(&game);
    // gameLoop.join();

    GameWindow gameWindow;
    gameWindow.setup(&game, screens[screens.size()-1].frame);
    gameWindow.show();

    // AppWindow appWindow;
    // appWindow.show();

    return app.exec();
}

po::variables_map parseArgs(int argc, char *argv[]) {
    po::options_description desc("Allowed options");
    desc.add_options()
        ("help,h", "Shows this help message")
        ("species", po::value<std::vector<std::string>>()->multitoken(), "Species of pets to spawn")
        ("screens", po::value<std::vector<std::string>>()->multitoken(), "Monitors the app will display on");

    po::variables_map vm;
    po::store(po::parse_command_line(argc, argv, desc), vm);
    po::notify(vm);

    if (vm.count("help")) {
        std::cout << desc << "\n";
    }
    return vm;
}

std::vector<Screen> screensMatching(po::variables_map args) {
    if (args.count("screens")) {
        auto names = args["screens"].as<std::vector<std::string>>();
        auto screens = screensMatching(names);

        if (screens.size() == 0) {
            std::cerr << "No matching screens found! The following one(s) should be available:" << std::endl;

            for (const Screen& screen : listAvailableScreens()) {
                std::cerr << "  - " << screen.description() << std::endl;
            }
            std::exit(EXIT_FAILURE);
        }
        return screens;
    } else {
        auto screens = listAvailableScreens();
        if (screens.size() == 0) {
            std::cerr << "No screen found!" << std::endl;
            std::exit(EXIT_FAILURE);
        }
        return screens;
    }
}

std::vector<std::string> selectedSpecies(po::variables_map args) {
    if (args.count("species")) {
        return args["species"].as<std::vector<std::string>>();
    } else {
        std::cerr << "No species selected, plase run with `--species ape` or something" << std::endl;
        std::exit(EXIT_FAILURE);
    }
}

