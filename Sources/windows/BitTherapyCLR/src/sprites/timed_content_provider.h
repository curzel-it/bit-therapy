#pragma once

#include <chrono>
#include <vector>

template<typename T>
class TimedContentProvider {
private:
    std::vector<T> frames;
    std::chrono::milliseconds frameDuration;
    uint32_t currentFrameIndex;
    long completedLoops;
    std::chrono::milliseconds lastUpdateTime;
    std::chrono::milliseconds lastFrameChangeTime;

    void loadNextFrame();
    void checkLoopCompletion(uint32_t nextIndex);

public:
    TimedContentProvider(const std::vector<T> frames, double fps);
    const T& currentFrame() const;
    void update(std::chrono::milliseconds timeSinceLastUpdate);
    const uint32_t numberOfFrames() const;
};
