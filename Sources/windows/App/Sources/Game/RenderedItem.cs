using App;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App
{
    public struct RenderedItem
    {
        public uint Id { get; }
        public string SpritePath { get; }
        public Rect Frame { get; }
        public bool IsFlipped { get; }
        public double ZRotation { get; }

        public RenderedItem(uint id, string spritePath, Rect frame, bool isFlipped, double zRotation)
        {
            Id = id;
            SpritePath = spritePath;
            Frame = frame;
            IsFlipped = isFlipped;
            ZRotation = zRotation;
        }
    }
}
