#include "sprite.h"
#include "timed_content_provider.h"

#include <chrono>
#include <iostream>
#include <string>
#include <vector>

Sprite::Sprite(const std::vector<std::string> frames, double fps) : timedContentProvider(frames, fps) {}

const std::string& Sprite::currentFrame() const {    
    return timedContentProvider.currentFrame();
}

void Sprite::update(std::chrono::milliseconds timeSinceLastUpdate) {
    timedContentProvider.update(timeSinceLastUpdate);
}

const uint32_t Sprite::numberOfFrames() const {
    return timedContentProvider.numberOfFrames();
}