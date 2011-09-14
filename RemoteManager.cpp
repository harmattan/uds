#include "RemoteManager.h"

#include <QtCore/QDebug>

#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkReply>
#include <QtNetwork/QNetworkRequest>

RemoteManager::RemoteManager(QObject *parent) :
    QObject(parent)
{
}

RemoteManager::~RemoteManager()
{
}

void RemoteManager::update()
{
    qDebug() << Q_FUNC_INFO << "START";

    QNetworkAccessManager *networkAccessManager = new QNetworkAccessManager(this);
    connect(networkAccessManager, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(parseReply(QNetworkReply*)));
    networkAccessManager->get(QNetworkRequest(QUrl("http://summit.ubuntu.com/uds-o.ical")));

    qDebug() << Q_FUNC_INFO << "END";
}

void RemoteManager::parseReply(QNetworkReply *reply)
{
    qDebug() << Q_FUNC_INFO << "START";

    Q_ASSERT(reply->error() == QNetworkReply::NoError);

    reply->open(QIODevice::ReadOnly | QIODevice::Text);
//    QVersitReader reader(reply);
//    if (!reader.startReading())
//        qFatal("START READING FAILED");
//    if (!reader.waitForFinished())
//        qFatal("WAITING FOR FINISHED FAILED");
//    QList<QVersitDocument> inputDocuments = reader.results();
//    Q_ASSERT(inputDocuments.count() > 0);

//    QVersitOrganizerImporter importer;
//    if (!importer.importDocument(inputDocuments.at(0)))
//        qFatal("Death to all of you!!!!!!!");
//    qDebug() << "PEACE!!!";

//    QOrganizerManager manager;
////    QOrganizerCollection collection;
////    collection.setMetaData(QOrganizerCollection::KeyName, QLatin1String("com.ubuntu.summit"));
////    manager.saveCollection(&collection);
//    foreach (QOrganizerItem item, importer.items()) {
////        item.setCollectionId(collection.id());
//        manager.saveItem(&item);
//    }

////    QOrganizerItemCollectionFilter filter;
////    filter.setCollectionId(collection.id());
////    qDebug() << manager.items(filter);
////    qDebug() << collection;
////    qDebug() << manager.collections();

    emit itemsChanged(reply->readAll());

    reply->manager()->deleteLater();
    reply->deleteLater();

    qDebug() << Q_FUNC_INFO << "END";
}
