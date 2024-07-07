#pragma once

#include <chrono>
#include <vector>

enum AnimationCurve {
    linear = 0
};

class Animator {
private:
    double initialValue;
    double finalValue;
    double currentValue;
    double incrementPerMillisecond;
    bool isActive;
    AnimationCurve animationCurve;
    
public:
    Animator();

    void animate(
        double initialValue, 
        double finalValue, 
        std::chrono::milliseconds duration,
        AnimationCurve animationCurve
    );

    void update(std::chrono::milliseconds timeSinceLastUpdate);

    const double current() const;
};