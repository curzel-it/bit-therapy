#include "vector_utils.h"

#include <gtest/gtest.h>
#include <functional>
#include <string>
#include <vector>

TEST(VectorUtilsTests, CanRemoveDuplicates) {
    std::vector<int> all({1, 2, 2, 2, 3, 4});
    std::vector<int> expected({1, 2, 3, 4});

    auto result = distinct(all);

    EXPECT_EQ(result, expected);
}

TEST(VectorUtilsTests, CanRemoveDuplicatesWithoutSideEffects) {
    std::vector<int> all({1, 2, 2, 2, 3, 4});
    std::vector<int> allOriginal({1, 2, 2, 2, 3, 4});
    std::vector<int> expected({1, 2, 3, 4});

    auto result = distinct(all);

    EXPECT_EQ(result, expected);
    EXPECT_EQ(all, allOriginal);
}
