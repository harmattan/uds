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

import QtQuick 1.0
import com.ubuntu.summit 1.0
import "../core/weekday.js" as WeekDay

ListWindow {
    id: window
    anchors.fill: parent

    property alias model: filtermodel.sourceModel
    property int dayOfWeek: -1

    title: dayOfWeek > -1 ? WeekDay.numberToString(dayOfWeek) : ""
    model: FilterProxyModel { id: filtermodel; dateFilter: dayOfWeek }
    delegate: ListDelegate {
        title.text: display

        onClicked: {
            windowStack.push(createWindow(Qt.resolvedUrl("SessionInfoWindow.qml"),
                                          {
                                              title: model.summary,
                                              dtstart: model.startDateTime,
                                              dtend: model.endDateTime,
                                              location: model.location,
                                              description: model.description,
                                              track: model.track,
                                              room: model.room
                                          }))
        }
    }
}
