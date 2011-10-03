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
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import com.ubuntu.summit 1.0
import "constants.js" as UI
import "../core/weekday.js" as WeekDay
import "."

Page {
    property int dayOfWeek: -1
    property alias model: filtermodel.sourceModel
    property alias title: header.title

    anchors.fill: parent
    tools: commonTools

    Item {
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        ListView {
            id: listview
            anchors.fill: parent
            anchors.margins: 10
            clip: true

            model: FilterProxyModel { id: filtermodel; dateFilter: dayOfWeek }

            delegate: ListDelegate {
                title: display
                subtitle: room
                onClicked: {
                    appWindow.pageStack.push(Qt.resolvedUrl("EventPage.qml"),
                                             {
                                                 summary: model.summary,
                                                 dtstart: model.startDateTime,
                                                 dtend: model.endDateTime,
                                                 location: model.location,
                                                 description: model.description,
                                                 track: model.track,
                                                 room: model.room
                                             })
                }

                ToolIcon {
                    platformIconId: "common-drilldown-arrow".concat(theme.inverted ? "-inverse" : "")
                    anchors.right: parent.right;
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
        ScrollDecorator { flickableItem: listview }
    }

    PageHeader { id: header; title: WeekDay.numberToString(dayOfWeek) }
}
