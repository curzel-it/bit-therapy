#ifndef APP_WINDOW_H
#define APP_WINDOW_H

#include <QWidget>

class AppWindow {    
private:
    QWidget window;

    void setup();

public:
    explicit AppWindow();
    void show();
};

#endif
