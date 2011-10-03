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

#ifndef DECLARATIVESHELL_H
#define DECLARATIVESHELL_H

#include <QtCore/QObject>

class QDeclarativeComponent;
class QDeclarativeContext;
class QDeclarativeEngine;

class DeclarativeShell : public QObject
{
    Q_OBJECT
public:
    DeclarativeShell(QObject *parent = 0);
    ~DeclarativeShell();

    void setMainQmlFile(const QString &file);

    QDeclarativeEngine *engine() const;
    QDeclarativeContext *rootContext() const;

    // Discard, needed for compatiblity with qmlappviewer
    void showExpanded() {}

private:
    QDeclarativeComponent *m_component;
    QDeclarativeEngine *m_engine;
};

#endif // DECLARATIVESHELL_H
