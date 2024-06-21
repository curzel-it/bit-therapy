#include "vector_utils.h"

#include <gtest/gtest.h>
#include <functional>
#include <string>
#include <vector>

TEST(VectorUtilsTests, CanRemoveDuplicates) {
    std::vector<uint32_t> all({1, 2, 2, 2, 3, 4});
    std::vector<uint32_t> expected({1, 2, 3, 4});

    auto result = distinct(all);

    EXPECT_EQ(result, expected);
}

TEST(VectorUtilsTests, CanRemoveDuplicatesWithoutSideEffects) {
    std::vector<uint32_t> all({1, 2, 2, 2, 3, 4});
    std::vector<uint32_t> allOriginal({1, 2, 2, 2, 3, 4});
    std::vector<uint32_t> expected({1, 2, 3, 4});

    auto result = distinct(all);

    EXPECT_EQ(result, expected);
    EXPECT_EQ(all, allOriginal);
}
