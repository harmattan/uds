#include "SessionModel.h"

#include <QtCore/QDebug>

#include "qcalevent.h"

SessionModel::SessionModel(QObject *parent) :
    QAbstractTableModel(parent)
{
    QHash<int, QByteArray> roles;
    roles[Qt::DisplayRole] = "display";
    roles[UidRole] = "uid";
    roles[StartDateTimeRole] = "startDateTime";
    roles[EndDateTimeRole] = "endDateTime";
    roles[CategoriesRole] = "categories";
    roles[SummaryRole] = "summary";
    roles[LocationRole] = "location";
    roles[DescriptionRole] = "description";
    roles[UrlRole] = "url";
    roles[TrackRole] = "track";
    roles[RoomNameRole] = "room";
    setRoleNames(roles);
//    m_columns = roles.count() + 1;
}

void SessionModel::setEvents(const EventList &events)
{
    m_events = events;
}

int SessionModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) {
        qDebug() << Q_FUNC_INFO << "valid";
        return 50;
    }
//    qDebug() << Q_FUNC_INFO << "invalid";
    return m_events.count();
}

int SessionModel::columnCount(const QModelIndex &parent) const
{
    if (parent.isValid()) {
        qDebug() << Q_FUNC_INFO << "valid";
        return 50;
    }
//    qDebug() << Q_FUNC_INFO << "invalid";
    return 1;
}

QVariant SessionModel::data(const QModelIndex &index, int role) const
{
    QSharedPointer<QCalEvent> event = m_events.at(index.row());

    switch (static_cast<Qt::ItemDataRole>(role)) {
    case Qt::DisplayRole:
        return event->summary();
//        return QVariant(QString("French fries"));
        break;
    }

    switch (static_cast<EventRole>(role)) {
    case UidRole:
        return event->summary();
    case StartDateTimeRole:
        return event->dtstart();
    case EndDateTimeRole:
        return event->dtend();
    case CategoriesRole:
        return event->categories();
    case SummaryRole:
        return event->summary();
    case LocationRole:
        return event->location();
    case DescriptionRole:
        return event->description();
    case UrlRole:
        return event->url();
    case TrackRole:
        return event->property("x_type");
    case RoomNameRole:
        return event->property("x_roomname");
    }
    qDebug() << Q_FUNC_INFO << "unhandled role" << role << "for index" << index;


    return QVariant();
}
