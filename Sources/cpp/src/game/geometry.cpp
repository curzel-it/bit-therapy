#include "geometry.h"

#include <sstream>
#include <iomanip> 

Vector2d::Vector2d(double x, double y) : x(x), y(y) {};

double Vector2d::magnitude() const {
    return sqrt(x * x + y * y);
}

Vector2d Vector2d::operator+(const Vector2d& other) const {
    return Vector2d(x + other.x, y + other.y);
}

Vector2d Vector2d::operator*(double scalar) const {
    return Vector2d(x * scalar, y * scalar);
}

bool Vector2d::operator==(const Vector2d& other) const {
    return x == other.x && y == other.y;
}

bool Vector2d::operator!=(const Vector2d& other) const {
    return x != other.x || y != other.y;
}

Rect::Rect(double x, double y, double w, double h) : x(x), y(y), w(w), h(h) {};

bool Rect::operator==(const Rect& other) const {
    return x == other.x && y == other.y && w == other.w && h == other.h;
}

bool Rect::operator!=(const Rect& other) const {
    return x != other.x || y != other.y || w != other.w || h != other.h;
}

Rect Rect::offset(const Vector2d& v) const {
    return Rect(x + v.x, y + v.y, w, h);
}

std::string Rect::description() const {
    std::stringstream ss; 
    ss << std::fixed << std::setprecision(1);
    ss << "{ x: " << x << ", y: " << y << ", w: " << w << ", h: " << h << " }";
    return ss.str();
}