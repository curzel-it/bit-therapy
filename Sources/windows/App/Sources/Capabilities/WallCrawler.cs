using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App
{
    public class WallCrawler : EntityCapability
    {
        private Rect bounds;

        public WallCrawler(Rect bounds)
        {
            this.bounds = bounds;
        }

        public override void Update(TimeSpan timeSinceLastUpdate, Entity entity)
        {
            if (entity.Direction.X > 0 && entity.Frame.MaxX() >= bounds.W)
            {
                entity.Direction.X = 0.0;
                entity.Direction.Y = -1.0;
                entity.Frame.X = bounds.W - entity.Frame.W;
                return;
            }
            if (entity.Direction.X < 0 && entity.Frame.X <= bounds.X)
            {
                entity.Direction.X = 0.0;
                entity.Direction.Y = 1.0;
                entity.Frame.X = 0.0;
                return;
            }
            if (entity.Direction.Y > 0 && entity.Frame.MaxY() >= bounds.H)
            {
                entity.Direction.X = entity.Frame.X == bounds.X ? 1.0 : -1.0;
                entity.Direction.Y = 0.0;
                entity.Frame.Y = bounds.H - entity.Frame.H;
                return;
            }
            if (entity.Direction.Y < 0 && entity.Frame.Y <= bounds.Y - entity.Frame.H)
            {
                entity.Direction.X = 0.0;
                entity.Direction.Y = 1.0;

                if (entity.Frame.X == bounds.X)
                {
                    entity.Frame.X = bounds.W - entity.Frame.W;
                } else
                {
                    entity.Frame.X = bounds.X;
                }
                return;
            }
        }
    }
}