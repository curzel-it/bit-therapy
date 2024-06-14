#ifndef GEOMETRY_H
#define GEOMETRY_H

#include <cmath>

struct Vector2d {
    double x, y;

    Vector2d(double x = 0.0, double y = 0.0);

    double magnitude() const;

    Vector2d operator+(const Vector2d& other) const;
    Vector2d operator*(double scalar) const;
    
    bool operator==(const Vector2d& other) const;
    bool operator!=(const Vector2d& other) const;
};

struct Rect {
    double x, y, w, h;

    Rect(double x, double y, double w, double h);

    bool operator==(const Rect& other) const;
    bool operator!=(const Rect& other) const;

    Rect offset(const Vector2d& v) const;
};

#endif
