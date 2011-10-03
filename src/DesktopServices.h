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
