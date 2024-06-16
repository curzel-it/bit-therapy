#ifndef TIMED_CONTENT_PROVIDER_H
#define TIMED_CONTENT_PROVIDER_H

#include <vector>

template<typename T>
class TimedContentProvider {
private:
    std::vector<T> frames;
    int frameDuration;
    int currentFrameIndex;
    long completedLoops;
    long lastUpdateTime;
    long lastFrameChangeTime;

public:
    TimedContentProvider(const std::vector<T> frames, double fps);
    const T& currentFrame() const;
    void update(long timeSinceLastUpdate);

private:
    void loadNextFrame();
    void checkLoopCompletion(int nextIndex);
};

#endif
