#include "timed_content_provider.h"
#include <gtest/gtest.h>

TEST(TimedContentProviderTests, CurrentFrame) {
    TimedContentProvider<int> provider({10, 20, 30}, 1.0);
    EXPECT_EQ(10, provider.currentFrame());
}

TEST(TimedContentProviderTests, NextFrameAdvance) {
    TimedContentProvider<int> provider({10, 20, 30}, 1.0);
    
    provider.update(500);
    EXPECT_EQ(10, provider.currentFrame());
    
    provider.update(500);
    EXPECT_EQ(20, provider.currentFrame());
    
    provider.update(1000);
    EXPECT_EQ(30, provider.currentFrame());
}

TEST(TimedContentProviderTests, InsufficientTimeDoesNotAdvanceFrame) {
    TimedContentProvider<int> provider({10, 20, 30}, 1.0);
    
    provider.update(300);
    EXPECT_EQ(10, provider.currentFrame());
    
    provider.update(300);
    EXPECT_EQ(10, provider.currentFrame());
    
    provider.update(300);
    EXPECT_EQ(10, provider.currentFrame());
    
    provider.update(300);
    EXPECT_EQ(20, provider.currentFrame());
    
    provider.update(1000);
    EXPECT_EQ(30, provider.currentFrame());
}