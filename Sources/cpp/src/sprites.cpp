#include "sprites.h"
#include "timed_content_provider.h"

#include <vector>
#include <string>

Sprite::Sprite(const std::vector<std::string> frames, double fps)
    : timed_content_provider(frames, fps) {}

const std::string& Sprite::current_frame() const {
    return timed_content_provider.current_frame();
}

void Sprite::update(long time_since_last_update) {
    timed_content_provider.update(time_since_last_update);
}

