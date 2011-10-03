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
import "constants.js" as UI

Rectangle {
    id: title

    property alias title: titleText.text
    property alias backgroundColor: title.color

    height: 72
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
//        color: "#0886CE"
    color: "#E3683D"

    Text {
        id: titleText
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 20
        font.pixelSize: 28
        font.family: UI.FONT_FAMILY_BOLD
        color: "white"
    }
}
