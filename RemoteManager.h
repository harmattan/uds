#ifndef REMOTEMANAGER_H
#define REMOTEMANAGER_H

#include <QtCore/QObject>

class QNetworkReply;

class RemoteManager : public QObject
{
    Q_OBJECT
public:
    explicit RemoteManager(QObject *parent = 0);
    ~RemoteManager();

signals:
    void itemsChanged(QString);

public slots:
    void update();

private slots:
    void parseReply(QNetworkReply *reply);
};

#endif // REMOTEMANAGER_H
