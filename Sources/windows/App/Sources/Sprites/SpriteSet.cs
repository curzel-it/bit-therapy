using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App
{
    public class SpriteSet
    {
        private Dictionary<string, List<string>> animations;

        public SpriteSet(Dictionary<string, List<string>> animations)
        {
            this.animations = animations;
        }

        public SpriteSet() : this(new Dictionary<string, List<string>>())
        {
        }

        public List<string> SpriteFrames(string animationName)
        {
            return animations.TryGetValue(animationName, out var frames) ? frames : new List<string> { "" };
        }

        public Sprite CreateSprite(string animationName, double fps)
        {
            var frames = SpriteFrames(animationName);
            return new Sprite(animationName, frames, fps);
        }
    }
}
