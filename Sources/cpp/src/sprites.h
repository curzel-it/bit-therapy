#ifndef SPRITES_H
#define SPRITES_H

#include <cmath>
#include <string>
#include <vector>
#include "timed_content_provider.h"

struct Sprite {
private:
    TimedContentProvider<std::string> timed_content_provider;

public:
    Sprite(const std::vector<std::string> frames, double fps);
    const std::string& currentFrame() const;
    void update(long time_since_last_update);
};

#endif
