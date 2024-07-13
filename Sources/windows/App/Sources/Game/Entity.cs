using App;
using App;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Policy;
using System.Text;
using System.Threading.Tasks;

namespace App
{
    public class Entity
    {
        private double fps;
        private SpriteSet spriteSet;
        private List<EntityCapability> capabilities;
        private Sprite currentSprite;

        private void SetupSpeed(double speedMultiplier)
        {
            Speed = 30.0 * Species.Speed * speedMultiplier;
        }

        public uint Id { get; set; }
        public Rect Frame { get; set; }
        public Vector2d Direction { get; set; }
        public double Speed { get; set; }
        public Species Species { get; set; }

        public Entity(uint id, double fps, double speedMultiplier, Species species, SpriteSet spriteSet, Rect frame)
        {
            Id = id;
            this.fps = fps;
            Speed = 0.0;
            Species = species;
            this.spriteSet = spriteSet;
            Frame = frame;
            Direction = new Vector2d(1.0, 0.0);
            capabilities = new List<EntityCapability>();
            currentSprite = new Sprite("", new List<string>(), 1.0);

            var movementSprite = species.MovementPath;
            SetupSpeed(speedMultiplier);
            ChangeSprite(movementSprite);
        }

        public string CurrentSpriteFrame()
        {
            return currentSprite.CurrentFrame;
        }

        public void Update(TimeSpan timeSinceLastUpdate)
        {
            foreach (var capability in capabilities)
            {
                capability.Update(timeSinceLastUpdate, this);
            }
            currentSprite.Update(timeSinceLastUpdate);
        }

        public void AddCapability(EntityCapability capability)
        {
            capabilities.Add(capability);
        }

        public uint ChangeSprite(string animationName)
        {
            if (currentSprite.AnimationName != animationName)
            {
                currentSprite = spriteSet.CreateSprite(animationName, fps);
            }
            return (uint)(1000 * currentSprite.NumberOfFrames / fps);
        }

        public string Description()
        {
            var spriteName = FileUtils.FileName(CurrentSpriteFrame());
            var sb = new StringBuilder();

            sb.AppendLine($"Entity @ {this}");
            sb.AppendLine($"  Species: {Species.Id}");
            sb.AppendLine($"  Sprite: {spriteName}");
            sb.AppendLine($"  dx: {Direction.X}");
            sb.AppendLine($"  dy: {Direction.Y}");
            sb.AppendLine($"  x: {Frame.X}");
            sb.AppendLine($"  y: {Frame.Y}");
            sb.AppendLine($"  w: {Frame.W}");
            sb.AppendLine($"  h: {Frame.H}");

            return sb.ToString();
        }
    }
}
