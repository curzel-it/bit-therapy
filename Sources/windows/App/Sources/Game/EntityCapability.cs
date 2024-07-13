using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App
{
    public abstract class EntityCapability
    {
        public abstract void Update(TimeSpan timeSinceLastUpdate, Entity entity);
    }
}
