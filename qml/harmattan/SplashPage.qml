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
import "../core"
import "../core/api.js" as API
import "../core/core.js" as Core

Page {
    id: page

    property date startDate
    property date endDate

    anchors.fill: parent

    JsonHandler {
        id: handler

        onListModelChanged: {
            var info = listModel.get(listModel.count - 1)
            title.text = info.title
            location.text = info.location
            page.startDate = info.date_start
            page.endDate = info.date_end
            time.text = Qt.formatDate(page.startDate) + ' - ' + Qt.formatDate(page.endDate)
            Core.settings().setValue("name", info.name)
            Core.update()
        }
    }

    Column {
        id: column
        anchors.centerIn: parent
        spacing: 10

        Image { anchors.horizontalCenter: parent.horizontalCenter; source: '../images/icon164.png' }
        Label {
            id: title
            width: page.width
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter;
            font.pixelSize: platformStyle.fontPixelSize*1.5;
        }
        Label {
            id: location
            width: page.width
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Label {
            id: time
            width: page.width
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
        BusyIndicator { anchors.horizontalCenter: parent.horizontalCenter; running: true }
    }

    Component.onCompleted: handler.load(API.summit)
}
