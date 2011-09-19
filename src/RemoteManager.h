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

class NetworkParserRunnable : public ParserRunnable
{
    Q_OBJECT
public:
    NetworkParserRunnable(const QUrl &url);

private slots:
    void run();
    void parseReply(QNetworkReply *reply);

private:
    NetworkParserRunnable() {}

    QUrl m_url;
    QEventLoop *m_eventLoop;
};

class RemoteManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(SessionModel *sessionModel READ sessionModel NOTIFY sessionModelChanged)
public:
    explicit RemoteManager(const QString &modelName,
                           QDeclarativeContext *rootContext,
                           QObject *parent = 0);
    ~RemoteManager();

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
    QDeclarativeContext *m_rootContext;
    QList<EventList> m_list;

    SessionModel *m_sessionModel;

};

#endif // REMOTEMANAGER_H