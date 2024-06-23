#pragma once

#include <QApplication>
#include <QScreen>
#include <QDebug>
#include <vector>
#include <string>

#include "../game/game.h"

struct Screen {
    std::string name;
    Rect frame;

    Screen(const std::string &name, const Rect &frame);

    const std::string description() const;

    bool operator==(const Screen& other) const;
};

std::vector<Screen> listAvailableScreens();
std::vector<Screen> filteredByNameParts(std::vector<Screen> allScreens, std::vector<std::string> names);
std::vector<Screen> screensMatching(std::vector<std::string> names);