#include "timed_content_provider.h"

#include <chrono>
#include <gtest/gtest.h>

TEST(TimedContentProviderTests, CurrentFrame) {
    TimedContentProvider<uint32_t> provider({10, 20, 30}, 1.0);
    EXPECT_EQ(10, provider.currentFrame());
}

TEST(TimedContentProviderTests, NextFrameAdvance) {
    TimedContentProvider<uint32_t> provider({10, 20, 30}, 1.0);
    
    provider.update(std::chrono::milliseconds(500));
    EXPECT_EQ(10, provider.currentFrame());
    
    provider.update(std::chrono::milliseconds(500));
    EXPECT_EQ(20, provider.currentFrame());
    
    provider.update(std::chrono::milliseconds(1000));
    EXPECT_EQ(30, provider.currentFrame());
}

TEST(TimedContentProviderTests, InsufficientTimeDoesNotAdvanceFrame) {
    TimedContentProvider<uint32_t> provider({10, 20, 30}, 1.0);
    
    provider.update(std::chrono::milliseconds(300));
    EXPECT_EQ(10, provider.currentFrame());
    
    provider.update(std::chrono::milliseconds(300));
    EXPECT_EQ(10, provider.currentFrame());
    
    provider.update(std::chrono::milliseconds(300));
    EXPECT_EQ(10, provider.currentFrame());
    
    provider.update(std::chrono::milliseconds(300));
    EXPECT_EQ(20, provider.currentFrame());
    
    provider.update(std::chrono::milliseconds(1000));
    EXPECT_EQ(30, provider.currentFrame());
}