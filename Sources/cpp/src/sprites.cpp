#include "sprites.h"
#include "timed_content_provider.h"

#include <iostream>
#include <string>
#include <vector>

Sprite::Sprite(const std::vector<std::string> frames, double fps) : timedContentProvider(frames, fps) {}

const std::string& Sprite::currentFrame() const {    
    return timedContentProvider.currentFrame();
}

void Sprite::update(long timeSinceLastUpdate) {
    timedContentProvider.update(timeSinceLastUpdate);
}