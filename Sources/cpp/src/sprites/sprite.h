#pragma once

#include <chrono>
#include <cmath>
#include <string>
#include <vector>
#include "timed_content_provider.h"

class Sprite {
private:
    TimedContentProvider<std::string> timedContentProvider;

public:
    Sprite(const std::vector<std::string> frames, double fps);
    const std::string& currentFrame() const;
    const uint32_t numberOfFrames() const;
    void update(std::chrono::milliseconds timeSinceLastUpdate);
};
