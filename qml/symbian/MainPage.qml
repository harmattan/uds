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

import QtQuick 1.1
import com.nokia.symbian 1.0
import "../core"

Page {
    property alias busy: busyIndicator.running

    Item {
        anchors.fill: parent

        ListView {
            clip: true
            anchors.fill: parent
            visible: !busyIndicator.visible
            model: DayListModel{}
            delegate: ListItem {
                subItemIndicator: true
                ListItemText { text: name }
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("ListPage.qml"),
                                   {
                                       title: name,
                                       dayOfWeek: number,
                                       model: mainCalendar.sessionModel
                                   })
                }
            }
        }

        BusyIndicator {
            id: busyIndicator
            anchors.centerIn: parent
            running: true
            visible: running
        }
    }
}
