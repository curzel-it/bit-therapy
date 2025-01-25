using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App
{
    public class LinearMovement : EntityCapability
    {
        public override void Update(TimeSpan timeSinceLastUpdate, Entity entity)
        {
            var frameDuration = timeSinceLastUpdate.TotalMilliseconds;
            var offset = entity.Direction * entity.Speed * frameDuration * 0.001;
            var updatedFrame = entity.Frame.Offset(offset);
            entity.Frame = updatedFrame;
        }
    }
}
