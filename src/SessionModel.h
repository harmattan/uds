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

#ifndef SESSIONMODEL_H
#define SESSIONMODEL_H

#include <QtCore/QAbstractTableModel>
#include <QtCore/QDateTime>
#include <QtCore/QSharedPointer>
#include <QtGui/QSortFilterProxyModel>

class QCalEvent;

class SessionModel : public QAbstractTableModel
{
    Q_OBJECT
public:
    typedef QList<QSharedPointer<QCalEvent> > EventList;

    enum EventRole {
        UidRole = Qt::UserRole + 1,
        StartDateTimeRole,
        EndDateTimeRole,
        CategoriesRole,
        SummaryRole,
        LocationRole,
        DescriptionRole,
        UrlRole,
        TrackRole,
        RoomNameRole,
        LastEventRole = RoomNameRole
    };

    enum DayRole {
        MondayRole = LastEventRole + 1,
        TuesdayRole,
        WednesdayRole,
        ThursdayRole,
        FridayRole,
        SaturdayRole,
        SundayRole
    };

    explicit SessionModel(QObject *parent = 0);
    void setEvents(const EventList &events);

    int rowCount(const QModelIndex &parent) const;
    int columnCount(const QModelIndex &parent) const;

    QVariant data(const QModelIndex &index, int role) const;

    // Provided by QAbstractTableModel
//    QModelIndex index(int row, int column, const QModelIndex &parent) const;
//    QModelIndex parent(const QModelIndex &child) const;

// TODO
//    QVariant headerData(int section, Qt::Orientation orientation, int role) const;

private:
    EventList m_events;
};

class FilterProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(int dateFilter READ dateFilter WRITE setDateFilter)
    Q_PROPERTY(SessionModel *sourceModel READ sourceModel WRITE setSourceModel)
public:
    FilterProxyModel(QObject *parent = 0) : QSortFilterProxyModel(parent), m_sourceModel(0), m_dateFilter(-1) {}

    SessionModel *sourceModel() const { return m_sourceModel; }
    void setSourceModel(SessionModel *sourceModel)
    {
        beginResetModel();
        m_sourceModel = sourceModel;
        QSortFilterProxyModel::setSourceModel(sourceModel);
        endResetModel();
    }

    int dateFilter() const { return m_dateFilter; }
    void setDateFilter(int filter) { m_dateFilter = filter; }

    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
    {
        QModelIndex index = sourceModel()->index(sourceRow, 0, sourceParent);

        if (m_dateFilter > -1)
            return index.data(SessionModel::StartDateTimeRole).value<QDateTime>().date().dayOfWeek() == m_dateFilter;

        return true;
    }

private:
    SessionModel *m_sourceModel;
    int m_dateFilter;
};

#endif // SESSIONMODEL_H
