#include "RemoteManager.h"

#include <QtCore/QDebug>
#include <QtCore/QDir>
#include <QtCore/QFile>
#include <QtCore/QStringBuilder>
#include <QtCore/QStringList>
#include <QtGui/QDesktopServices>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QNetworkRequest>

#ifdef UDS_WITH_KCAL
#include <kcalcoren/icalformat.h>
#include <kcalcoren/memorycalendar.h>
using namespace KCalCore;
#endif // UDS_WITH_KCAL

RemoteManager::RemoteManager(QObject *parent) :
    QObject(parent)
{
}

RemoteManager::~RemoteManager()
{
    qDebug() << Q_FUNC_INFO << this;
}

void RemoteManager::update(const QUrl &url)
{
    qDebug() << Q_FUNC_INFO << this << "START";
    qDebug() << url;

    QFile cacheFile(cacheFilePath(url));
    if (cacheFile.exists()) {
        cacheFile.open(QIODevice::ReadOnly | QIODevice::Text);
        emit (itemsChanged(cacheFile.readAll()));
    }

    QNetworkAccessManager *networkAccessManager = new QNetworkAccessManager(this);
    connect(networkAccessManager, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(parseReply(QNetworkReply*)));
    networkAccessManager->get(QNetworkRequest(url));

    qDebug() << Q_FUNC_INFO << this << "END";
}

void RemoteManager::parseReply(QNetworkReply *reply)
{
    qDebug() << Q_FUNC_INFO << this << "START";

    Q_ASSERT(reply->error() == QNetworkReply::NoError);

    reply->open(QIODevice::ReadOnly | QIODevice::Text);
    QByteArray data = reply->readAll();

    const QString cacheDirPath = QDesktopServices::storageLocation(QDesktopServices::CacheLocation);
    QDir cacheDir(cacheDirPath);
    if (!cacheDir.exists())
        cacheDir.mkpath(cacheDirPath);

    QFile f(cacheFilePath(reply->url()));
    if (!f.open(QIODevice::WriteOnly | QIODevice::Text))
        qWarning() << "Faield to open cache file for" << reply->url() << "for writing!";
    f.write(data);
    f.close();

    emit itemsChanged(data);

#ifdef UDS_WITH_KCAL
    MemoryCalendar::Ptr cal = MemoryCalendar::Ptr(new MemoryCalendar(QLatin1String("UTC")));
    ICalFormat format;
    format.fromRawString(cal, data);

    KCalCore::Event::List list = cal->rawEvents();
    foreach (const KCalCore::Event::Ptr event, list) {
        qDebug() << event->summary();
    }
#endif // UDS_WITH_KCAL

    reply->manager()->deleteLater();
    reply->deleteLater();
    deleteLater(); // Dangerous!!!!

    qDebug() << Q_FUNC_INFO << this << "END";
}

inline QString RemoteManager::cacheFilePath(const QUrl &url)
{
    const QString cacheDirPath = QDesktopServices::storageLocation(QDesktopServices::CacheLocation);
    return cacheDirPath % QLatin1Literal("/") %  url.path().split("/").last();
}
