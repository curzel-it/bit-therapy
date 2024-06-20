#ifndef timedContentProvider_H
#define timedContentProvider_H

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
