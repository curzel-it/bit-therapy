#ifndef APP_WINDOW_H
#define APP_WINDOW_H

#include <QLabel>
#include <QWidget>

class AppWindow : public QWidget {    
    Q_OBJECT

private:
    QLabel * title;

    void buildUi();

public:
    AppWindow(QWidget *parent = nullptr);
};

#endif
