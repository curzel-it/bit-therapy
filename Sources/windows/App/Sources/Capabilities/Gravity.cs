using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App
{
    public class Gravity : EntityCapability
    {
        private Vector2d gravityAcceleration;
        private double groundY;

        public Gravity(double groundY)
        {
            this.gravityAcceleration = new Vector2d(0, 9.81);
            this.groundY = groundY;
        }

        public override void Update(TimeSpan timeSinceLastUpdate, Entity entity)
        {
            if (Math.Abs(entity.Direction.X) < 0.0001)
            {
                return;
            }
            if (entity.Frame.MaxY() < groundY)
            {
                double timeStep = timeSinceLastUpdate.TotalMilliseconds / 1000.0;
                Vector2d gravityEffect = gravityAcceleration * timeStep;
                var dragSprite = entity.Species.DragPath;

                entity.Direction = entity.Direction + gravityEffect;
                entity.ChangeSprite(dragSprite);
            } else if (entity.Direction.Y > 0.0)
            {
                var dx = entity.Direction.X > 0 ? 1.0 : -1.0;
                var movementSprite = entity.Species.MovementPath;

                entity.Frame.Y = groundY - entity.Frame.H;
                entity.Direction = new Vector2d(dx, 0.0);
                entity.ChangeSprite(movementSprite);
            }
        }
    }
}
