#include "screens.h"

#include <sstream>

Screen::Screen(const std::string &name, const Rect &frame) : 
    name(name), 
    frame(frame) 
{}

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
        screens.emplace_back(
            screen->name().toStdString(), 
            Rect(geom.x(), geom.y(), geom.width(), geom.height())
        );
    }
    return screens;
}