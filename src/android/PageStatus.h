#ifndef PAGESTATUS_H
#define PAGESTATUS_H

#include <QtCore/QObject>

class PageStatus : public QObject
{
    Q_OBJECT
    Q_ENUMS(Status)
public:
    enum Status {
        Inactive,
        Activating,
        Active,
        Deactivating
    };
};

#endif // PAGESTATUS_H
