using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App
{
    public enum AnimationCurve
    {
        Linear = 0
    }

    public class Animator
    {
        private double initialValue;
        private double finalValue;
        private double currentValue;
        private double incrementPerMillisecond;
        private bool isActive;
        private AnimationCurve animationCurve;

        public Animator()
        {
            initialValue = 0;
            finalValue = 0;
            currentValue = 0;
            incrementPerMillisecond = 0;
            animationCurve = AnimationCurve.Linear;
            isActive = false;
        }

        public void Animate(double initialValue, double finalValue, TimeSpan duration, AnimationCurve animationCurve)
        {
            this.currentValue = initialValue;
            this.initialValue = initialValue;
            this.finalValue = finalValue;
            this.animationCurve = animationCurve;

            var diff = finalValue - initialValue;
            var durationMs = duration.TotalMilliseconds;
            this.incrementPerMillisecond = diff / durationMs;

            this.isActive = true;
        }

        public void Update(TimeSpan timeSinceLastUpdate)
        {
            if (!isActive) return;

            var elapsedMs = timeSinceLastUpdate.TotalMilliseconds;
            currentValue = currentValue + elapsedMs * incrementPerMillisecond;

            if (currentValue >= finalValue)
            {
                currentValue = finalValue;
                isActive = false;
            }
        }

        public double Current()
        {
            return currentValue;
        }
    }
}
