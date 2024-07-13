using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App
{
    public struct SpriteFrame : IEquatable<SpriteFrame>
    {
        public string Path { get; set; }
        public string Species { get; set; }
        public string Animation { get; set; }
        public uint Index { get; set; }

        public bool Equals(SpriteFrame other)
        {
            return Path == other.Path && Species == other.Species && Animation == other.Animation;
        }

        public override bool Equals(object obj)
        {
            return obj is SpriteFrame other && Equals(other);
        }

        public override int GetHashCode()
        {
            return HashCode.Combine(Path, Species, Animation);
        }

        public static bool operator ==(SpriteFrame left, SpriteFrame right)
        {
            return left.Equals(right);
        }

        public static bool operator !=(SpriteFrame left, SpriteFrame right)
        {
            return !(left == right);
        }
    }
}
