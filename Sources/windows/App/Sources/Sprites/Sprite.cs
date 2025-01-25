using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App
{
    public class Sprite
    {
        private TimedContentProvider<string> timedContentProvider;

        public Sprite(string animationName, List<string> frames, double fps)
        {
            this.AnimationName = animationName;
            this.timedContentProvider = new TimedContentProvider<string>(frames, fps);
        }

        public string AnimationName { get; private set; }

        public string CurrentFrame => timedContentProvider.CurrentFrame;

        public uint NumberOfFrames => (uint)timedContentProvider.NumberOfFrames;

        public void Update(TimeSpan timeSinceLastUpdate)
        {
            timedContentProvider.Update(timeSinceLastUpdate);
        }
    }
}
