#include "sprite_set.h"

#include <gtest/gtest.h>
#include <vector>
#include <string>

std::vector<std::string> generate_sprite_names(const std::string& base_name, uint32_t count) {
    std::vector<std::string> names;
    for (uint32_t i = 0; i < count; i++) {
        names.push_back(base_name + "-" + std::to_string(i));
    }
    return names;
}

TEST(SpriteSetTests, CanReferenceStandardSprites) {
    std::vector<std::string> movement = generate_sprite_names(SPRITE_NAME_MOVEMENT, 3);
    std::vector<std::string> fall = generate_sprite_names(SPRITE_NAME_FALL, 3);
    std::vector<std::string> front = generate_sprite_names(SPRITE_NAME_FRONT, 3);
    std::map<std::string, std::vector<std::string>> animations;

    SpriteSet sprite_set(movement, fall, front, animations);

    ASSERT_EQ(sprite_set.spriteFrames(SPRITE_NAME_MOVEMENT)[0], "movement-0");
    ASSERT_EQ(sprite_set.spriteFrames(SPRITE_NAME_FALL)[0], "fall-0");
    ASSERT_EQ(sprite_set.spriteFrames(SPRITE_NAME_FRONT)[0], "front-0");
}

TEST(SpriteSetTests, CanReferenceAnimations) {
    std::map<std::string, std::vector<std::string>> animations;
    animations["jump"] = generate_sprite_names("jump", 5);
    animations["run"] = generate_sprite_names("run", 5);
    animations["slide"] = generate_sprite_names("slide", 5);

    SpriteSet sprite_set({}, {}, {}, animations);

    ASSERT_EQ(sprite_set.spriteFrames("jump")[0], "jump-0");
    ASSERT_EQ(sprite_set.spriteFrames("run")[0], "run-0");
    ASSERT_EQ(sprite_set.spriteFrames("slide")[0], "slide-0");
}
