using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App
{
    public class Vector2d
    {
        public double X;
        public double Y;

        public Vector2d(double x, double y)
        {
            X = x;
            Y = y;
        }

        public double Magnitude()
        {
            return Math.Sqrt(X * X + Y * Y);
        }

        public static Vector2d operator +(Vector2d a, Vector2d b)
        {
            return new Vector2d(a.X + b.X, a.Y + b.Y);
        }

        public static Vector2d operator *(Vector2d a, double scalar)
        {
            return new Vector2d(a.X * scalar, a.Y * scalar);
        }

        public override bool Equals(object obj)
        {
            if (obj is Vector2d other)
            {
                return X == other.X && Y == other.Y;
            }
            return false;
        }

        public override int GetHashCode()
        {
            return HashCode.Combine(X, Y);
        }

        public static bool operator ==(Vector2d a, Vector2d b)
        {
            return a.Equals(b);
        }

        public static bool operator !=(Vector2d a, Vector2d b)
        {
            return !a.Equals(b);
        }
    }
}
