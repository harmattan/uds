#include "AndroidQmlAppViewer.h"

#include <QtCore/QDebug>
#include <QtGui/QCloseEvent>

AndroidQmlAppViewer::AndroidQmlAppViewer(QWidget *parent) :
    QmlApplicationViewer(parent),
    m_closePressed(false)
{
}

void AndroidQmlAppViewer::closeEvent(QCloseEvent *event)
{
    qDebug() << Q_FUNC_INFO << event->spontaneous();

    // Spontanous (i.e. originated from outside the system) close requests are
    // ignored if the back key was pressed.
    // This is to work around a major misdesign in QtAndroid where it will trigger
    // a close event on every press on back, which is of course only desirable
    // if our QML PageStack is empty. So we simply ignore all spontanous events
    // that seem to be caused by this bogus behaviour. Other spontanous events
    // are processed as expected (system asking us to quit to get memory etc.).
    if (event->spontaneous() && m_closePressed) {
        event->setAccepted(false);
        m_closePressed = false;
        return;
    }

    QmlApplicationViewer::closeEvent(event);
}

void AndroidQmlAppViewer::keyPressEvent(QKeyEvent *event)
{
    qDebug() << Q_FUNC_INFO;
    if (event->key() == Qt::Key_Close)
        m_closePressed = true;
    QmlApplicationViewer::keyPressEvent(event);
}
