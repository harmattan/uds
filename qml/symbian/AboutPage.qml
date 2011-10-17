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
import com.nokia.symbian 1.0
import "../core"
import "../core/about.js" as About

Page {
    id: page

    objectName: "aboutPage"
    anchors.fill: parent
    anchors.margins: 32

    Row {
        id: headerContainer
        spacing: 10
        Image { id: icon; source: "../images/icon80.png" }
        Label {
            anchors.verticalCenter: icon.verticalCenter
            text: "12.04";
            font.pixelSize: 32; font.bold: true; font.family: "Nokia Pure Text Bold"
        }
        Image {
            anchors.verticalCenter: icon.verticalCenter
            source: "../images/gplv3.png"
            MouseArea { anchors.fill: parent; onClicked: Qt.openUrlExternally(About.gplUrl) }
        }
    }

    Item {
        anchors {
            top: headerContainer.bottom; topMargin: 40;
            bottom: parent.bottom;
            left: parent.left; right: parent.right
        }

        ListView {
            anchors.fill: parent
            boundsBehavior: Flickable.StopAtBounds
            clip: true
            model: AboutModel {}
            delegate: ListDelegate {
                title: "© " + year + " " + name
                subtitle: "<a href=\"mailto:" + mail + "\">" + mail + "</a>"
                onClicked: Qt.openUrlExternally("mailto:" + mail)
            }
        }
    }
}
