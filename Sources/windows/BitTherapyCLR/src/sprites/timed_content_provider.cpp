#include "timed_content_provider.h"

#include <chrono>
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
    auto frameDurationMs = fps > 0.0f ? 1000.0 / fps : 0;
    frameDuration = std::chrono::milliseconds(uint32_t(frameDurationMs));
}

template<typename T>
const uint32_t TimedContentProvider<T>::numberOfFrames() const {
    return frames.size();
}

template<typename T>
const T& TimedContentProvider<T>::currentFrame() const {
    return frames[currentFrameIndex];
}

template<typename T>
void TimedContentProvider<T>::update(std::chrono::milliseconds timeSinceLastUpdate) {
    lastUpdateTime += timeSinceLastUpdate;

    if ((lastUpdateTime - lastFrameChangeTime) >= frameDuration) {
        loadNextFrame();
        lastFrameChangeTime = lastUpdateTime;
    }
}

template<typename T>
void TimedContentProvider<T>::loadNextFrame() {
    auto original = currentFrameIndex;
    uint32_t nextIndex = (currentFrameIndex + 1) % frames.size();
    checkLoopCompletion(nextIndex);
    currentFrameIndex = nextIndex;
    auto frame = currentFrame();
}

template<typename T>
void TimedContentProvider<T>::checkLoopCompletion(uint32_t nextIndex) {
    if (nextIndex < currentFrameIndex) {
        completedLoops++;
    }
}

template class TimedContentProvider<uint32_t>;
template class TimedContentProvider<std::string>;
