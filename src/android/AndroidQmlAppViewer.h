#ifndef ANDROIDQMLAPPVIEWER_H
#define ANDROIDQMLAPPVIEWER_H

#include "../qmlapplicationviewer/qmlapplicationviewer.h"

class AndroidQmlAppViewer : public QmlApplicationViewer
{
    Q_OBJECT
public:
    explicit AndroidQmlAppViewer(QWidget *parent = 0);

protected:
    void closeEvent(QCloseEvent *);
    void keyPressEvent(QKeyEvent *);

private:
    bool m_closePressed;
};

#endif // ANDROIDQMLAPPVIEWER_H
