#include "entity.h"
#include "game.h"
#include "game_renderer.h"
#include "game_renderer_impl.h"
#include "sprites.h"
#include "vector_utils.h"

#include <string>
#include <vector>

std::vector<RenderedItem> GameRendererImpl::render(const Game * game) const {
    return std::vector<RenderedItem>({});
}