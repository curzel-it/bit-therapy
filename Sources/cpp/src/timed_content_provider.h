#ifndef timedContentProvider_H
#define timedContentProvider_H

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

public:
    TimedContentProvider(const std::vector<T> frames, double fps);
    const T& currentFrame() const;
    void update(std::chrono::milliseconds timeSinceLastUpdate);

private:
    void loadNextFrame();
    void checkLoopCompletion(uint32_t nextIndex);
};

#endif
