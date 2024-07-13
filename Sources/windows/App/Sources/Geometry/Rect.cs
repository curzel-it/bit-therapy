using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App
{
    public class Rect
    {
        public double X;
        public double Y;
        public double W;
        public double H;

        public Rect(double x, double y, double w, double h)
        {
            X = x;
            Y = y;
            W = w;
            H = h;
        }

        public Rect Offset(Vector2d v)
        {
            return Offset(v.X, v.Y);
        }

        public Rect Offset(double deltaX, double deltaY)
        {
            return new Rect(X + deltaX, Y + deltaY, W, H);
        }

        public double MaxX()
        {
            return X + W;
        }

        public double MaxY()
        {
            return Y + H;
        }

        public string Description()
        {
            return string.Format(CultureInfo.InvariantCulture, "{{ x: {0:0.0}, y: {1:0.0}, w: {2:0.0}, h: {3:0.0} }}", X, Y, W, H);
        }

        public override bool Equals(object obj)
        {
            if (obj is Rect other)
            {
                return X == other.X && Y == other.Y && W == other.W && H == other.H;
            }
            return false;
        }

        public override int GetHashCode()
        {
            return HashCode.Combine(X, Y, W, H);
        }

        public static bool operator ==(Rect a, Rect b)
        {
            return a.Equals(b);
        }

        public static bool operator !=(Rect a, Rect b)
        {
            return !a.Equals(b);
        }
    }
}
