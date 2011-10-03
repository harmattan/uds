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

#include "RemoteManager.h"

#include <QtCore/QDebug>
#include <QtCore/QDir>
#include <QtCore/QEventLoop>
#include <QtCore/QFile>
#include <QtCore/QStringBuilder>
#include <QtCore/QStringList>
#include <QtCore/QThreadPool>
#include <QtGui/QDesktopServices>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QNetworkRequest>

#include "qcalevent.h"
#include "qcalparser.h"

#include "SessionModel.h"

// ---------------------------------- File ---------------------------------- //

void FileParserRunnable::run()
{
    QFile cacheFile(m_path);
    if (cacheFile.exists() ||
            !cacheFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        cacheFile.open(QIODevice::ReadOnly | QIODevice::Text);

        QCalParser parser;
        parser.parse(&cacheFile);
        emit done(parser.eventList());
    } else {
        qDebug() << Q_FUNC_INFO;
        qWarning("File '%s' could not be opened for reading.", qPrintable(m_path));
        emit done(QList<QSharedPointer<QCalEvent> >());
    }
}

// --------------------------------- Network -------------------------------- //

NetworkParserRunnable::NetworkParserRunnable(const QUrl &url):
    m_url(url)
{
    setAutoDelete(false);
}

void NetworkParserRunnable::run()
{
    qDebug() << Q_FUNC_INFO << "START";
    QNetworkAccessManager *networkAccessManager = new QNetworkAccessManager;
    connect(networkAccessManager, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(parseReply(QNetworkReply*)), Qt::QueuedConnection);
    networkAccessManager->get(QNetworkRequest(m_url));

    // Needed to actually do anything with QNAM
    m_eventLoop = new QEventLoop;
    m_eventLoop->exec();
}

void NetworkParserRunnable::parseReply(QNetworkReply *reply)
{
    qDebug() << Q_FUNC_INFO << "START";
    Q_ASSERT(reply->error() == QNetworkReply::NoError);

    reply->open(QIODevice::ReadOnly | QIODevice::Text);
    QByteArray data = reply->readAll();

    const QString cacheDirPath = QDesktopServices::storageLocation(QDesktopServices::CacheLocation);
    QDir cacheDir(cacheDirPath);
    if (!cacheDir.exists())
        cacheDir.mkpath(cacheDirPath);

    QFile f(RemoteManager::cacheFilePath(reply->url()));
    if (!f.open(QIODevice::WriteOnly | QIODevice::Text))
        qWarning() << "Failed to open cache file for" << reply->url() << "for writing!";
    f.write(data);
    f.close();

    QCalParser parser;
    parser.parse(data);
    emit done(parser.eventList());

    reply->manager()->deleteLater();
    deleteLater();
    m_eventLoop->exit(0);
    m_eventLoop->deleteLater();
}

// --------------------------------- Manager -------------------------------- //

RemoteManager::RemoteManager(QObject *parent) :
    QObject(parent),
    m_sessionModel(new SessionModel(this))
{
    qRegisterMetaType<QList<QSharedPointer<QCalEvent> > >("QList<QSharedPointer<QCalEvent> >");
}

RemoteManager::~RemoteManager()
{
    foreach (EventList list, m_list)
        qDeleteAll(list);
}

void RemoteManager::update(const QUrl &url)
{
    qDebug() << Q_FUNC_INFO << "START" << thread();
    NetworkParserRunnable *parser = new NetworkParserRunnable(url);
    connect(parser, SIGNAL(done(QList<QSharedPointer<QCalEvent> >)),
            this, SLOT(parsingDone(QList<QSharedPointer<QCalEvent> >)),
            Qt::QueuedConnection);
    QThreadPool::globalInstance()->start(parser);
}

void RemoteManager::updateFromCache(const QUrl &url)
{
    qDebug() << Q_FUNC_INFO << "START";
    FileParserRunnable *parser = new FileParserRunnable(cacheFilePath(url));
    connect(parser, SIGNAL(done(QList<QSharedPointer<QCalEvent> >)),
            this, SLOT(parsingDone(QList<QSharedPointer<QCalEvent> >)),
            Qt::QueuedConnection);
    QThreadPool::globalInstance()->start(parser);
}

void RemoteManager::parsingDone(QList<QSharedPointer<QCalEvent> > events)
{
    qDebug() << Q_FUNC_INFO << "START" << events.count();
    m_sessionModel->setEvents(events);
    emit sessionModelChanged();
    emit eventsChanged();
}

inline QString RemoteManager::cacheFilePath(const QUrl &url)
{
    const QString cacheDirPath = QDesktopServices::storageLocation(QDesktopServices::CacheLocation);
    qDebug() << Q_FUNC_INFO << cacheDirPath % QLatin1Literal("/") %  url.path().split("/").last();
    return cacheDirPath % QLatin1Literal("/") %  url.path().split("/").last();
}
