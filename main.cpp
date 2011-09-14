#include <QtCore/QStringBuilder>
#include <QtCore/QThread>

#include <QtDeclarative/QDeclarativeContext>
#include <QtDeclarative/QDeclarativeEngine>
#include <QtDeclarative/QDeclarativeView>
#include <QtDeclarative/qdeclarative.h>

#include <QtGui/QApplication>

#ifdef Q_WS_MAEMO_6
#include <applauncherd/MDeclarativeCache>
#include "banner.h"
#else
#include "qmlapplicationviewer.h"
#endif

#include "RemoteManager.h"

int main(int argc, char *argv[])
{
//    QUrl source;
#ifdef Q_WS_MAEMO_6
    QScopedPointer<QApplication> app(MDeclarativeCache::qApplication(argc, argv));
    QScopedPointer<QDeclarativeView> view(MDeclarativeCache::qDeclarativeView());
    QObject::connect(view->engine(), SIGNAL(quit()), view.data(), SLOT(close()));

    qmlRegisterType<Banner>("UDS", 1, 0, "Banner");
#else
    QScopedPointer<QApplication> app(new QApplication(argc, argv));
    QScopedPointer<QmlApplicationViewer> view(new QmlApplicationViewer());
    view->setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
#endif

    qmlRegisterType<RemoteManager>();
    RemoteManager manager;
//    QThread thread;
//    thread.start();
//    manager.moveToThread(&thread);
    view->rootContext()->setContextProperty("remoteManager", &manager);

#ifdef Q_WS_MAEMO_6
    view->setSource(QUrl::fromLocalFile(MDeclarativeCache::applicationDirPath()
                    % QLatin1Literal("/../qml/ubuntudevelopersummit/main.qml")));
    view->showFullScreen();
#else
    view->setMainQmlFile(QLatin1String("qml/desktop/main.qml"));
    view->showExpanded();
#endif

    return app->exec();
}
