#pragma once

#include <chrono>

#include "../game/game.h"

class WallCrawler : public EntityCapability {
    Rect bounds;

public:
    WallCrawler(Rect bounds);

    void update(std::chrono::milliseconds timeSinceLastUpdate, Entity * entity) override;
};
