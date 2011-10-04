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

#ifndef REMOTEMANAGER_H
#define REMOTEMANAGER_H

#include <QtCore/QObject>
#include <QtCore/QRunnable>
#include <QtCore/QSharedPointer>
#include <QtCore/QUrl>
#include <QtDeclarative/QDeclarativeListProperty>

class QCalEvent;
class QDeclarativeContext;
class QEventLoop;
class QNetworkAccessManager;
class QNetworkReply;
class SessionModel;
class QUrl;

typedef QList<QObject *> EventList;

Q_DECLARE_METATYPE(QCalEvent*)
Q_DECLARE_METATYPE(QList<QCalEvent*>)
//Q_DECLARE_METATYPE(QList<QList<QCalEvent*> >)

class ParserRunnable :public QObject, public QRunnable
{
    Q_OBJECT
signals:
    void done(QList<QSharedPointer<QCalEvent> > events);
};

class FileParserRunnable : public ParserRunnable
{
public:
    FileParserRunnable(const QString path) : m_path(path) {}
    void run();

private:
    FileParserRunnable() {}
    QString m_path;
};

class NetworkParser : public ParserRunnable
{
    Q_OBJECT
public:
    NetworkParser();

private slots:
    void parseReply(QNetworkReply *reply);

private:
    void run() {}
};

class RemoteManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(SessionModel *sessionModel READ sessionModel NOTIFY sessionModelChanged)
public:
    explicit RemoteManager(QObject *parent = 0);
    ~RemoteManager();

    Q_INVOKABLE void clearCache(const QUrl &url);
    Q_INVOKABLE bool hasCache(const QUrl &url) const;
    static QString cacheFilePath(const QUrl &url);

    SessionModel *sessionModel() const { return m_sessionModel; }
    void setSessionModel(SessionModel *model) { m_sessionModel = model; emit sessionModelChanged(); }

signals:
    void sessionModelChanged();
    void eventsChanged();

public slots:
    void update(const QUrl &url);
    void updateFromCache(const QUrl &url);

private slots:
    void parsingDone(QList<QSharedPointer<QCalEvent> > events);

private:
    QList<EventList> m_list;

    SessionModel *m_sessionModel;
};

#endif // REMOTEMANAGER_H
