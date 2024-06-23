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
};

std::vector<Screen> listAvailableScreens();