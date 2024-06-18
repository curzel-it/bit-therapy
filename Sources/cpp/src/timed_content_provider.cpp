#include "timed_content_provider.h"

#include <iostream>
#include <vector>

template<typename T>
TimedContentProvider<T>::TimedContentProvider(const std::vector<T> frames, double fps)
    : frames(frames),
      currentFrameIndex(0),
      completedLoops(0),
      lastUpdateTime(0),
      lastFrameChangeTime(0)
{
    frameDuration = fps > 0.0f ? static_cast<long>(1000.0 / fps) : 0;
}

template<typename T>
const T& TimedContentProvider<T>::currentFrame() const {
    return frames[currentFrameIndex];
}

template<typename T>
void TimedContentProvider<T>::update(long timeSinceLastUpdate) {
    lastUpdateTime += timeSinceLastUpdate;

    if ((lastUpdateTime - lastFrameChangeTime) >= frameDuration) {
        loadNextFrame();
        lastFrameChangeTime = lastUpdateTime;
    }
}

template<typename T>
void TimedContentProvider<T>::loadNextFrame() {
    auto original = currentFrameIndex;
    int nextIndex = (currentFrameIndex + 1) % frames.size();
    checkLoopCompletion(nextIndex);
    currentFrameIndex = nextIndex;
    auto frame = currentFrame();
}

template<typename T>
void TimedContentProvider<T>::checkLoopCompletion(int nextIndex) {
    if (nextIndex < currentFrameIndex) {
        completedLoops++;
    }
}

template class TimedContentProvider<int>;
template class TimedContentProvider<std::string>;
