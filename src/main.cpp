/*
    Copyright (C) 2011 Harald Sitter <apachelogger@ubuntu.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <QtCore/QStringBuilder>
#include <QtCore/QThread>

#include <QtDeclarative/QDeclarativeContext>
#include <QtDeclarative/QDeclarativeEngine>
#include <QtDeclarative/QDeclarativeView>
#include <QtDeclarative/qdeclarative.h>

#include <QtGui/QApplication>

#include "qcalevent.h"

#ifdef Q_WS_HARMATTAN
#include <applauncherd/MDeclarativeCache>
#elif Q_WS_MAEMO_5
#include "maemo5/DeclarativeShell.h"
#include "maemo5/MenuGroup.h"
#include "maemo5/MenuItem.h"
#include "maemo5/Window.h"
#elif Q_WS_ANDROID
#include "android/AndroidQmlAppViewer.h"
#include "android/PageStatus.h"
#else
#include "qmlapplicationviewer.h"
#endif

#include "DesktopServices.h"
#include "RemoteManager.h"
#include "SessionModel.h"
#include "Settings.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
#ifdef Q_WS_HARMATTAN
    // Cannot use the qmlapplicationviewer overload for create() as that will
    // lead to view's rootcontext not being the actual execution context which
    // in turn breaks the manager injection (then again the injection should
    // be replaced with qml element usage as the managers are qobjects anyway).
    QScopedPointer<QApplication> app(MDeclarativeCache::qApplication(argc, argv));
    QScopedPointer<QDeclarativeView> view(MDeclarativeCache::qDeclarativeView());
    QObject::connect(view->engine(), SIGNAL(quit()), view.data(), SLOT(close()));
#elif Q_WS_MAEMO_5
    QScopedPointer<QApplication> app(new QApplication(argc, argv));
    QScopedPointer<DeclarativeShell> view(new DeclarativeShell());
#warning TODO
//    view->setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
#elif Q_WS_ANDROID
    QScopedPointer<QApplication> app(new QApplication(argc, argv));
    QScopedPointer<QmlApplicationViewer> view(new AndroidQmlAppViewer());
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

    const char uri[] = "com.ubuntu.summit";
    qmlRegisterType<DesktopServices>(uri, 1, 0, "DesktopServices");
    qmlRegisterType<FilterProxyModel>(uri, 1, 0, "FilterProxyModel");
    qmlRegisterType<Settings>(uri, 1, 0, "Settings");
#ifdef Q_WS_MAEMO_5
    const char maemoUri[] = "com.ubuntu.summit.maemo";
    qmlRegisterType<StackedWindow>(maemoUri, 5, 0, "StackedWindow");
    qmlRegisterType<MenuGroup>(maemoUri, 5, 0, "MenuGroup");
    qmlRegisterType<MenuItem>(maemoUri, 5, 0, "MenuItem");
    qmlRegisterType<Window>(maemoUri, 5, 0, "WindowBase");
    qmlRegisterType<WindowStack>();
#elif Q_WS_ANDROID
    const char androidUri[] = "com.ubuntu.summit.android";
    qmlRegisterUncreatableType<PageStatus>(androidUri, 1, 0, "PageStatus", "");
#endif

    QDeclarativeContext *rootContext = view->rootContext();
    RemoteManager mainCalendar;
    RemoteManager userCalendar;
    rootContext->setContextProperty("mainCalendar", &mainCalendar);
    rootContext->setContextProperty("userCalendar", &userCalendar);

    QString source =
        #ifdef Q_WS_HARMATTAN
            MDeclarativeCache::applicationDirPath() % QLatin1Literal("/../qml/harmattan/main.qml")
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

#ifdef Q_WS_HARMATTAN
    view->setSource(source);
    view->showFullScreen();
#else
    view->setMainQmlFile(source);
    view->showExpanded();
#endif

    return app->exec();
}
