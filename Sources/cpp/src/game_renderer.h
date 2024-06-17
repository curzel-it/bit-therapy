#ifndef GAME_RENDERER_H
#define GAME_RENDERER_H

#include "game.h"
#include "geometry.h"

#include <string>
#include <vector>

struct RenderedItem {
    public:
        std::string imagePath;
        Rect rect;
};

class GameRenderer {
public:
    virtual ~GameRenderer() = default;
    virtual std::vector<RenderedItem> render(const Game * game) const = 0;
};

#endif