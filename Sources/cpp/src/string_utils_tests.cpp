#include "string_utils.h"

#include <gtest/gtest.h>
#include <vector>
#include <string>

TEST(StringUtilsTests, StringReplace) {
    ASSERT_EQ(replace("ciao Bella", "ciao", "hi"), "hi Bella");
    ASSERT_EQ(replace("ciao", "c", "x"), "xiao");
    ASSERT_EQ(replace("ciao", "", "hi"), "ciao");
    ASSERT_EQ(replace("ciao", "hi", "xxx"), "ciao");
}

TEST(StringUtilsTests, StringReplaceWithoutSideEffects) {
    std::string initial = "ciao Bella";
    ASSERT_EQ(replace(initial, "ciao", "hi"), "hi Bella");
    ASSERT_EQ(initial, "ciao Bella");
}