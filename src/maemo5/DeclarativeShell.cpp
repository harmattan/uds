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
