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

#ifndef MENUGROUP_H
#define MENUGROUP_H

#include <QtDeclarative/QDeclarativeItem>

class QActionGroup;
class MenuGroup : public QDeclarativeItem
{
    Q_OBJECT
public:
    explicit MenuGroup(QDeclarativeItem *parent = 0);

    void componentComplete();

    QList<QAction *> actions() const { return m_actionGroup->actions(); }

private:
    QActionGroup *m_actionGroup;
};

#endif // MENUGROUP_H
