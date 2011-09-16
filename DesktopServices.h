#ifndef DESKTOPSERVICES_H
#define DESKTOPSERVICES_H

#include <QtCore/QObject>
#include <QtGui/QDesktopServices>

#define U_PROPERTY_GETTER(__cName) \
    public: QString __cName() const { return QDesktopServices::storageLocation(__cName); } private:

class DesktopServices : public QObject
{
    Q_OBJECT
//    Q_PROPERTY(QString desktopLocation READ DesktopLocation)
//    Q_PROPERTY(QString documentsLocation READ DocumentsLocation)
//    Q_PROPERTY(QString fontsLocation READ FontsLocation)
//    Q_PROPERTY(QString applicationsLocation READ ApplicationsLocation)
//    Q_PROPERTY(QString musicLocation READ MusicLocation)
//    Q_PROPERTY(QString moviesLocation READ MoviesLocation)
//    Q_PROPERTY(QString picturesLocation READ PicturesLocation)
//    Q_PROPERTY(QString tempLocation READ TempLocation)
//    Q_PROPERTY(QString homeLocation READ HomeLocation)
//    Q_PROPERTY(QString dataLocation READ DataLocation)
//    Q_PROPERTY(QString cacheLocation READ CacheLocation)
//    U_PROPERTY_GETTER(TempLocation)
//    U_PROPERTY_GETTER(HomeLocation)
//    U_PROPERTY_GETTER(DataLocation)
//    U_PROPERTY_GETTER(CacheLocation)
public:
    DesktopServices(QObject *parent = 0) : QObject(parent) {}
    ~DesktopServices() {}

public slots:
    bool openUrl(const QUrl &url) { return QDesktopServices::openUrl(url); }
};

#endif // DESKTOPSERVICES_H
