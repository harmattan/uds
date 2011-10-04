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

Sheet {
    acceptButtonText: qsTr("Save")
    rejectButtonText: qsTr("Cancel")

    content: Flickable {
        id: container
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.topMargin: 10
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: col
            width: parent.width
            spacing: 10

            Label { text: qsTr("Settings"); font.bold: true; }
            Label { text: qsTr("Launchpad Username:") }
            TextField {
                id: lpusername
                anchors { left: parent.left; right: parent.right; }
                height: implicitHeight
                inputMethodHints: Qt.ImhNoAutoUppercase

                Component.onCompleted: text = Core.settings().value("lpuser")
            }
            Button { text: "Clear Cache"; onClicked: Core.clearCache() }
        }
    }

    onAccepted: { Core.settings().setValue("lpuser", lpusername.text); destroy() }
    onRejected: destroy();
}
