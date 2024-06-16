#include "sprites.h"
#include "timed_content_provider.h"

#include <vector>
#include <string>

Sprite::Sprite(const std::vector<std::string> frames, double fps)
    : timed_content_provider(frames, fps) {}

const std::string& Sprite::currentFrame() const {
    return timed_content_provider.currentFrame();
}

void Sprite::update(long timeSinceLastUpdate) {
    timed_content_provider.update(timeSinceLastUpdate);
}