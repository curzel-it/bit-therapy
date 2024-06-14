#include <iostream>
#include "geometry.h"

int main() {
    Vector2d vector1(3.5, 2.5);
    Vector2d vector2(1.5, 4.0);

    Vector2d sum = vector1 + vector2;

    std::cout << "Sum of vectors: (" << sum.x << ", " << sum.y << ")" << std::endl;

    return 0;
}
