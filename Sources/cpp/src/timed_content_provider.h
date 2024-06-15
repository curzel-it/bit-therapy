#ifndef TIMED_CONTENT_PROVIDER_H
#define TIMED_CONTENT_PROVIDER_H

#include <vector>

template<typename T>
class TimedContentProvider {
private:
    std::vector<T> frames;
    int frame_duration;
    int currentFrame_index;
    long completed_loops;
    long last_update_time;
    long last_frame_change_time;

public:
    TimedContentProvider(const std::vector<T> frames, double fps);
    const T& currentFrame() const;
    void update(long time_since_last_update);

private:
    void loadNextFrame();
    void checkLoopCompletion(int next_index);
};

#endif
