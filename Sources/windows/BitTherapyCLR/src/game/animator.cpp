#include "animator.h"

#include <chrono>
#include <vector>

Animator::Animator() : 
    initialValue(0), 
    finalValue(0), 
    currentValue(0),
    incrementPerMillisecond(0),
    animationCurve(AnimationCurve::linear),
    isActive(false) 
{}

void Animator::animate(
    double initialValue, 
    double finalValue, 
    std::chrono::milliseconds duration,
    AnimationCurve animationCurve
) {
    this->currentValue = initialValue;
    this->initialValue = initialValue;
    this->finalValue = finalValue;
    this->animationCurve = animationCurve;

    auto diff = finalValue - initialValue;
    auto durationMs = 1000 * duration.count();
    this->incrementPerMillisecond = diff / durationMs;

    this->isActive = true;
}
    
void Animator::update(std::chrono::milliseconds timeSinceLastUpdate) {
    if (!isActive) { return; }
    auto elapsedMs = 1000 * timeSinceLastUpdate.count();
    currentValue = currentValue + elapsedMs * incrementPerMillisecond;

    if (currentValue >= finalValue) {
        currentValue = finalValue;
        isActive = false;
    }
}

const double Animator::current() const {
    return currentValue;
}