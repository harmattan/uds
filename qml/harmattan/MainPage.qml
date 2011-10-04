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
import "../core/core.js" as Core

Page {
    id: page

    anchors.fill: parent

    Column {
        anchors.centerIn: parent
        spacing: 10
        Image { anchors.horizontalCenter: parent.horizontalCenter; source: '../images/icon164.png' }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter;
            font.pixelSize: platformStyle.fontPixelSize*1.5;
            text: Core.__name
        }
        Label { anchors.horizontalCenter: parent.horizontalCenter; text: Core.__location }
        Label { anchors.horizontalCenter: parent.horizontalCenter; text: Core.__time }
        BusyIndicator { anchors.horizontalCenter: parent.horizontalCenter; running: true }
    }
}
