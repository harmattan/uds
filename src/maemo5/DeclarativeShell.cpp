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

#include "DeclarativeShell.h"

#include <QtCore/QCoreApplication>
#include <QtCore/QFileInfo>
#include <QtDeclarative/QDeclarativeComponent>
#include <QtDeclarative/QDeclarativeEngine>
#include <QtGui/QGraphicsObject>

DeclarativeShell::DeclarativeShell(QObject *parent) :
    QObject(parent),
    m_component(0),
    m_engine(new QDeclarativeEngine(this))
{
    connect(m_engine, SIGNAL(quit()), qApp, SLOT(quit()));
}

DeclarativeShell::~DeclarativeShell()
{
}

static QString adjustPath(const QString &path)
{
#ifdef Q_OS_UNIX
#ifdef Q_OS_MAC
    if (!QDir::isAbsolutePath(path))
        return QCoreApplication::applicationDirPath()
                + QLatin1String("/../Resources/") + path;
#else
    const QString pathInInstallDir = QCoreApplication::applicationDirPath()
        + QLatin1String("/../") + path;
    if (pathInInstallDir.contains(QLatin1String("opt"))
            && pathInInstallDir.contains(QLatin1String("bin"))
            && QFileInfo(pathInInstallDir).exists()) {
        return pathInInstallDir;
    }
#endif
#endif
    return path;
}

void DeclarativeShell::setMainQmlFile(const QString &file)
{
    QUrl url = QUrl::fromLocalFile(adjustPath(file));
    // FIXME this is all a bit flimsy
    m_component = new QDeclarativeComponent(m_engine, url, this);
    m_component->create(m_engine->rootContext());
}

inline QDeclarativeEngine *DeclarativeShell::engine() const
{
    return m_engine;
}

inline QDeclarativeContext *DeclarativeShell::rootContext() const
{
    return m_engine->rootContext();
}
