#ifndef GAME_RENDERER_IMPL_H
#define GAME_RENDERER_IMPL_H

#include "game_renderer.h"

#include <string>
#include <vector>

class GameRendererImpl : public GameRenderer {
    std::vector<RenderedItem> render(const Game * game) const override;
};

#endif 
