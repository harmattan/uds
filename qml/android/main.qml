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

PageStackWindow {
    id: window

    Page {
        id: pp
        Rectangle {
            anchors.fill: parent
            color: "orange"
        }
        Rectangle { anchors.centerIn: parent; width: 100; height: 100; color: "green"
            MouseArea {anchors.fill: parent; onClicked: pageStack.push(dd) }
        }
    }

    Page {
        id: dd
        Rectangle {
            anchors.fill: parent
            color: "green"
        }
        Rectangle { anchors.centerIn: parent; width: 100; height: 100; color: "blue"
            MouseArea {anchors.fill: parent; onClicked: pageStack.push(aa) }
        }
    }

    Page {
        id: aa
        Rectangle {
            anchors.fill: parent
            color: "blue"
        }
        Rectangle { anchors.centerIn: parent; width: 100; height: 100; color: "red"
            MouseArea {anchors.fill: parent; onClicked: pageStack.push(bb) }
        }
    }

    Page {
        id: bb
        Rectangle {
            anchors.fill: parent
            color: "red"
        }
        Rectangle { anchors.centerIn: parent; width: 100; height: 100; color: "yellow"
            MouseArea {anchors.fill: parent; onClicked: pageStack.push(cc) }
        }
    }

    Page {
        id: cc
        Rectangle {
            anchors.fill: parent
            color: "yellow"
        }
    }

    Keys.onPressed: {
        if (event.key == Qt.Key_TopMenu)
            console.debug("QML: opening menu!")
        else if (event.key == Qt.Key_Close) {
            console.debug("QML: closing! (maybe)")
            pageStack.depth <= 1 ? Qt.quit() : pageStack.pop()
        }
    }

    anchors.fill: parent
    focus: true

    Component.onCompleted: {
        pageStack.push(pp)
        pageStack.push(dd)
        pageStack.push(aa)
        pageStack.push(bb)
        pageStack.push(cc)
    }
}
