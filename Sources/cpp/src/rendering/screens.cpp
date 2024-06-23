#include "screens.h"

#include "../utils/string_utils.h"

#include <sstream>

Screen::Screen(const std::string &name, const Rect &frame) : 
    name(name), 
    frame(frame) 
{}

bool Screen::operator==(const Screen& other) const {
    return name == other.name && frame == other.frame;
}

const std::string Screen::description() const {
    std::stringstream ss; 
    ss << name << " | " << frame.description();
    return ss.str();
}

std::vector<Screen> listAvailableScreens() {
    std::vector<Screen> screens;
    const auto &qScreens = QGuiApplication::screens();

    for (QScreen *screen : qScreens) {
        QRect geom = screen->geometry();
        Screen newScreen(
            screen->name().toStdString(), 
            Rect(geom.x(), geom.y(), geom.width(), geom.height())
        );
        screens.push_back(newScreen);
    }
    return screens;
}

std::vector<Screen> filteredByNameParts(std::vector<Screen> allScreens, std::vector<std::string> names) {
    std::vector<Screen> matches;        

    for (const Screen& screen : allScreens) {
        for (const std::string& name : names) {
            auto screenName = lowered(screen.name);
            auto namePart = lowered(name);
            if (screenName.find(namePart) != std::string::npos) {
                matches.push_back(screen);
                break;
            }
        }
    }
    return matches;
}

std::vector<Screen> screensMatching(std::vector<std::string> names) {
    return filteredByNameParts(listAvailableScreens(), names);
}