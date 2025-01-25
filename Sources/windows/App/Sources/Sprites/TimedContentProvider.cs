using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App
{
    public class TimedContentProvider<T>
    {
        private List<T> frames;
        private TimeSpan frameDuration;
        private uint currentFrameIndex;
        private long completedLoops;
        private TimeSpan lastUpdateTime;
        private TimeSpan lastFrameChangeTime;

        public TimedContentProvider(List<T> frames, double fps)
        {
            this.frames = frames;
            currentFrameIndex = 0;
            completedLoops = 0;
            lastUpdateTime = TimeSpan.Zero;
            lastFrameChangeTime = TimeSpan.Zero;

            var frameDurationMs = fps > 0.0 ? 1000.0 / fps : 0;
            frameDuration = TimeSpan.FromMilliseconds(frameDurationMs);
        }

        public T CurrentFrame
        {
            get { return frames[(int)currentFrameIndex]; }
        }

        public void Update(TimeSpan timeSinceLastUpdate)
        {
            lastUpdateTime += timeSinceLastUpdate;

            if ((lastUpdateTime - lastFrameChangeTime) >= frameDuration)
            {
                LoadNextFrame();
                lastFrameChangeTime = lastUpdateTime;
            }
        }

        public uint NumberOfFrames
        {
            get { return (uint)frames.Count; }
        }

        private void LoadNextFrame()
        {
            var original = currentFrameIndex;
            uint nextIndex = (currentFrameIndex + 1) % (uint)frames.Count;
            CheckLoopCompletion(nextIndex);
            currentFrameIndex = nextIndex;
            var frame = CurrentFrame;
        }

        private void CheckLoopCompletion(uint nextIndex)
        {
            if (nextIndex < currentFrameIndex)
            {
                completedLoops++;
            }
        }
    }
}
