#include <QtCore/QStringBuilder>
#include <QtCore/QThread>

#include <QtDeclarative/QDeclarativeContext>
#include <QtDeclarative/QDeclarativeEngine>
#include <QtDeclarative/QDeclarativeView>
#include <QtDeclarative/qdeclarative.h>

#include <QtGui/QApplication>

#include "qcalevent.h"

#ifdef Q_WS_MAEMO_6
#include <applauncherd/MDeclarativeCache>
#elif Q_WS_MAEMO_5
#include <maemo5/DeclarativeShell.h>
#include <maemo5/Window.h>
#else
#include "qmlapplicationviewer.h"
#endif

#include "DesktopServices.h"
#include "RemoteManager.h"
#include "SessionModel.h"
#include "Settings.h"

int main(int argc, char *argv[])
{
#ifdef Q_WS_MAEMO_6
    QScopedPointer<QApplication> app(MDeclarativeCache::qApplication(argc, argv));
    QScopedPointer<QDeclarativeView> view(MDeclarativeCache::qDeclarativeView());
    QObject::connect(view->engine(), SIGNAL(quit()), view.data(), SLOT(close()));
#elif Q_WS_MAEMO_5
    QScopedPointer<QApplication> app(new QApplication(argc, argv));
    QScopedPointer<DeclarativeShell> view(new DeclarativeShell());
#warning TODO
//    view->setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
#else
    QScopedPointer<QApplication> app(new QApplication(argc, argv));
    QScopedPointer<QmlApplicationViewer> view(new QmlApplicationViewer());
    view->setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
#endif

    // For QSettings
    QCoreApplication::setOrganizationName("Ubuntu");
    QCoreApplication::setOrganizationDomain("ubuntu.com");
    QCoreApplication::setApplicationName("summit");

    qmlRegisterType<QCalEvent>();
    qmlRegisterType<RemoteManager>();
    qmlRegisterType<SessionModel>();

    qmlRegisterType<FilterProxyModel>("com.ubuntu.summit", 1, 0, "FilterProxyModel");
    qmlRegisterType<DesktopServices>("com.ubuntu.summit", 1, 0, "DesktopServices");
    qmlRegisterType<Settings>("com.ubuntu.summit", 1, 0, "Settings");
#ifdef Q_WS_MAEMO_5
    qmlRegisterType<StackedWindow>("com.ubuntu.summit.maemo", 5, 0, "StackedWindow");
    qmlRegisterType<Window>("com.ubuntu.summit.maemo", 5, 0, "Window");
    qmlRegisterType<WindowStack>();
#endif

    QDeclarativeContext *rootContext = view->rootContext();
    RemoteManager mainCalendar(QLatin1String("mainCalendar"), rootContext);
    RemoteManager userCalendar(QLatin1String("userCalendar"), rootContext);
    rootContext->setContextProperty("mainCalendar", &mainCalendar);
    rootContext->setContextProperty("userCalendar", &userCalendar);

    QString source =
        #ifdef Q_WS_MAEMO_6
            MDeclarativeCache::applicationDirPath() % QLatin1Literal("/../qml/ubuntudevelopersummit/main.qml")
        #elif Q_WS_MAEMO_5
            QLatin1String("qml/maemo5/main.qml")
        #elif Q_WS_SYMBIAN
            QLatin1String("qml/symbian/main.qml")
        #elif Q_WS_ANDROID
            QLatin1String("qrc:/qml/android/main.qml")
        #else
            QLatin1String("qml/desktop/main.qml")
        #endif
            ;

#ifdef Q_WS_MAEMO_6
    view->setSource(source);
    view->showFullScreen();
#else
    view->setMainQmlFile(source);
    view->showExpanded();
#endif // Q_WS_MAEMO_6

    return app->exec();
}
