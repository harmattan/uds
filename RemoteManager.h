#ifndef REMOTEMANAGER_H
#define REMOTEMANAGER_H

#include <QtCore/QObject>

class QNetworkReply;
class QUrl;

#ifdef UDS_WITH_KCAL
#include <kcalcoren/event.h>

class QmlEvent : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString uid READ uid)
    Q_PROPERTY(QDateTime start READ startDate)
    Q_PROPERTY(QDateTime end READ endDate)
    Q_PROPERTY(QStringList categories READ categories)
    Q_PROPERTY(QString summary READ summary)
    Q_PROPERTY(QString description READ description)
public:
    QmlEvent(KCalCore::Event::Ptr event) : m_event(event) {}
    ~QmlEvent() {}

    QString uid() const { return m_event->uid(); }
    QDateTime startDate() const { return m_event->dtStart().dateTime(); }
    QDateTime endDate() const { return m_event->dtEnd().dateTime(); }
    QStringList categories() const { return m_event->categories(); }
    QString summary() const { return m_event->summary(); }
    QString description() const { return m_event->description(); }

private:
    KCalCore::Event::Ptr m_event;
};
#endif // UDS_WITH_KCAL

class RemoteManager : public QObject
{
    Q_OBJECT
public:
    explicit RemoteManager(QObject *parent = 0);
    ~RemoteManager();

signals:
    void itemsChanged(QString);

public slots:
    void update(const QUrl &url);

private slots:
    void parseReply(QNetworkReply *reply);

private:
    QString cacheFilePath(const QUrl &url);
};

#endif // REMOTEMANAGER_H
