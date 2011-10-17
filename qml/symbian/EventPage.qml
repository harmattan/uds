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
import com.nokia.extras 1.0

Page {
    id: page

//    property alias summary: titleText.text
    property string summary
    property alias dtstart: dtstart.value
    property alias dtend: dtend.value
    property alias location: location.value
    property alias description: description.value
    property alias track: track.value
    property alias room: room.value

    anchors.fill: parent

    Flickable {
        id: flickable

//        anchors.topMargin: title.height + 10
        anchors.fill: parent
        anchors.margins: 20
        clip: true
        flickableDirection: Flickable.VerticalFlick
        contentWidth: container.width; contentHeight: container.height

        Item {
            id: container

            height: column.height + map.height
            width: column.width + map.width

            Column {
                id: column

                PropertyLabel { id: dtstart; label: "Start:"; }
                PropertyLabel { id: dtend; label: "End:"; }
                PropertyLabel { id: location; label: "Location:"; }
                PropertyLabel { id: description; label: "Description:"; }
                PropertyLabel { id: track; label: "Track:"; }
                PropertyLabel { id: room; label: "Room:"; }
            }

//            Image {
//                id: map

//                anchors.top: column.bottom
//                anchors.topMargin: 10
//                source: "../images/room-map.jpg"
//                width: page.width/2
//                fillMode: Image.PreserveAspectFit

//                MouseArea {
//                    anchors.fill: parent
//                    onClicked: {
//                        pageStack.push(Qt.createComponent("RoomMapPage.qml"))
//                    }
//                }
//            }
        }
    }

    ScrollDecorator { flickableItem: flickable }

//    Rectangle {
//        id: title
//        height: 72
//        anchors.top: parent.top
//        anchors.left: parent.left
//        anchors.right: parent.right
//        //        color: "#0886CE"
//        color: "#E3683D"

//        Label {
//            id: titleText
//            anchors.verticalCenter: parent.verticalCenter
//            verticalAlignment: Text.AlignVCenter
//            anchors.left: parent.left
//            anchors.leftMargin: 20
//            anchors.right: ratingContainer.left
//            font.pixelSize: 28
//            font.family: UI.FONT_FAMILY_BOLD
//            elide: Text.ElideRight
//            color: "white"
//            height: parent.height
//        }

//        Item {
//            id: ratingContainer
//            anchors.right: parent.right
//            anchors.verticalCenter: titleText.verticalCenter
//            width: rater.width + 32*2 // 32 is margin on each side
//            height: parent.height
//            RatingIndicator {
//                id: rater
//                anchors.centerIn: parent
//                maximumValue: 1
//                ratingValue: 0
//            }
//            MouseArea {
//                anchors.fill: parent
//                onClicked: rater.ratingValue = rater.ratingValue == 1 ? 0 : 1
//            }
//        }
//    }
}
