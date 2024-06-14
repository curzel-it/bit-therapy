#include "timed_content_provider.h"

#include <vector>

template<typename T>
TimedContentProvider<T>::TimedContentProvider(const std::vector<T> frames, double fps)
    : frames(frames),
      current_frame_index(0),
      completed_loops(0),
      last_update_time(0),
      last_frame_change_time(0)
{
    frame_duration = fps > 0.0f ? static_cast<long>(1000.0 / fps) : 0;
}

template<typename T>
const T& TimedContentProvider<T>::current_frame() const {
    return frames[current_frame_index];
}

template<typename T>
void TimedContentProvider<T>::update(long time_since_last_update) {
    last_update_time += time_since_last_update;

    if ((last_update_time - last_frame_change_time) >= frame_duration) {
        load_next_frame();
        last_frame_change_time = last_update_time;
    }
}

template<typename T>
void TimedContentProvider<T>::load_next_frame() {
    int next_index = (current_frame_index + 1) % frames.size();
    check_loop_completion(next_index);
    current_frame_index = next_index;
}

template<typename T>
void TimedContentProvider<T>::check_loop_completion(int next_index) {
    if (next_index < current_frame_index) {
        completed_loops++;
    }
}

template class TimedContentProvider<int>;
template class TimedContentProvider<std::string>;
