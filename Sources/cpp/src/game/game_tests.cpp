#include <chrono>
#include <gtest/gtest.h>
#include <iostream>
#include <string>
#include <vector>

#include "../capabilities/capabilities.h"
#include "../species/species.h"
#include "../sprites/sprites.h"

#include "game.h"
#include "geometry.h"

TEST(GameTests, CanUpdateCascade) {
    Game game(nullptr, nullptr, "test", 10.0, 10.0, 50.0);

    auto spriteSet = SpriteSet(
        std::vector<std::string>({"movement-0", "movement-1", "movement-2"}), 
        std::vector<std::string>({"fall-0", "fall-1", "fall-2"}),
        std::vector<std::string>({"front-0", "front-1", "front-2"}),
        std::map<std::string, std::vector<std::string>>({})
    );
    Rect initialFrame = Rect(0.0, 0.0, 1.0, 1.0);        
    Species species("test", 1.0, 1.0);            

    Entity ape(10.0, 50.0, 1.0, &species, &spriteSet, initialFrame);
    game.addEntity(&ape); 
    
    auto linearMovement = std::make_shared<LinearMovement>();
    ape.addCapability(linearMovement);

    std::vector<RenderedItem> results({});

    game.update(std::chrono::milliseconds(100));
    results = game.render();
    EXPECT_EQ(results.size(), 1);
    EXPECT_EQ(results[0].frame.x, 0.06);

    game.update(std::chrono::milliseconds(100));
    results = game.render();
    EXPECT_EQ(results.size(), 1);
    EXPECT_EQ(results[0].frame, Rect(0.12, 0.0, 1.0, 1.0));

    game.update(std::chrono::milliseconds(100));
    results = game.render();
    EXPECT_EQ(results.size(), 1);
    EXPECT_EQ(results[0].frame, Rect(0.18, 0.0, 1.0, 1.0));

    game.update(std::chrono::milliseconds(100));
    results = game.render();
    EXPECT_EQ(results.size(), 1);
    EXPECT_EQ(results[0].frame, Rect(0.24, 0.0, 1.0, 1.0));

    game.update(std::chrono::milliseconds(100));
    results = game.render();
    EXPECT_EQ(results.size(), 1);
    EXPECT_EQ(results[0].frame, Rect(0.3, 0.0, 1.0, 1.0));
};