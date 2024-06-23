#include "geometry.h"
#include <gtest/gtest.h>

TEST(Vector2dTests, SumVectors) {
    Vector2d vector1(3.5, 2.5);
    Vector2d vector2(1.5, 4.0);
    Vector2d result = vector1 + vector2;
    Vector2d expected(5.0, 6.5);
    EXPECT_EQ(result, expected);
}

TEST(Vector2dTests, ScalarProduct) {
    Vector2d vector1(1, 1);
    Vector2d expected(5.0, 5.0);
    EXPECT_EQ(vector1 * 5, expected);
}

TEST(Vector2dTests, Equals) {
    Vector2d vec1(1, 2);
    Vector2d vec2(1, 2);
    EXPECT_EQ(vec1, vec2);
}

TEST(Vector2dTests, NotEquals) {
    Vector2d vec1(1, 2);
    Vector2d vec2(2, 2);
    EXPECT_NE(vec1, vec2);
}


TEST(RectTests, Equals) {
    Rect rect1(0, 0, 1, 1);
    Rect rect2(0, 0, 1, 1);    
    EXPECT_EQ(rect1, rect2);
}

TEST(RectTests, NotEquals) {
    Rect rect1(0, 0, 1, 1);
    Rect rect2(0, 1, 1, 1);
    Rect rect3(0, 0, 2, 1);
    EXPECT_NE(rect1, rect2);
    EXPECT_NE(rect1, rect3);
}

TEST(RectTests, Offset) {
    Rect rect1(0, 0, 1, 1);
    Vector2d vec(0, 1);
    Rect expected(0, 1, 1, 1);
    EXPECT_EQ(rect1.offset(vec), expected);
}
