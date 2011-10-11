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
import "../core/"
import "../core/weekday.js" as WeekDay

Page {
    id: page

    property alias busy: busyIndicator.running
    property alias model: listview.model

    anchors.fill: parent
    tools: commonTools

    Item {
        anchors.top: title.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        BusyIndicator {
            id: busyIndicator
            anchors.centerIn: parent
            platformStyle: BusyIndicatorStyle { size: "large" }
            running: true
            visible: running
        }

        ListView {
            id: listview

            /** @returns name of day with first character having bigger font size */
            function formattedTitle(dayOfWeek, baseSize) {
                var name = WeekDay.numberToString(dayOfWeek)
                var firstChar = name.charAt(0)
                var rest = name.substr(1)
                return '<font size="' + baseSize * 1.5 + '">' + firstChar + '</font>' + rest
            }

            visible: !busyIndicator.running
            model: DayListModel {}
            anchors.fill: parent
            anchors.margins: 10
            clip: true

            delegate: ListDelegate {
                title: listview.formattedTitle(number, titleSize)
                onClicked: pageStack.push(Qt.resolvedUrl("ListPage.qml"),
                                          { dayOfWeek: number, model: mainCalendar.sessionModel })

                ToolIcon {
                    platformIconId: "common-drilldown-arrow".concat(theme.inverted ? "-inverse" : "")
                    anchors.right: parent.right;
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    PageHeader { id: title; title: qsTr("Ubuntu Developer Summit") }
}
