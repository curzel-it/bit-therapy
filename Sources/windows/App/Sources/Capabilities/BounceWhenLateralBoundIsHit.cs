using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App
{
    public class BounceWhenLateralBoundIsHit : EntityCapability
    {
        private double leftBound;
        private double rightBound;

        public BounceWhenLateralBoundIsHit(double leftBound, double rightBound)
        {
            this.leftBound = leftBound;
            this.rightBound = rightBound;
        }

        public override void Update(TimeSpan timeSinceLastUpdate, Entity entity)
        {
            if (entity.Frame.X < leftBound && entity.Direction.X < 0)
            {
                entity.Direction = new Vector2d(-1 * entity.Direction.X, entity.Direction.Y);
                entity.Frame.X = leftBound;
            }

            if (entity.Frame.MaxX() > rightBound && entity.Direction.X > 0)
            {
                entity.Direction = new Vector2d(-1 * entity.Direction.X, entity.Direction.Y);
                entity.Frame.X = rightBound - entity.Frame.W;
            }
        }
    }
}
