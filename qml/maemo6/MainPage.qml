import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    property alias column: column
    property alias busy: busyIndicator.running

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

//        ScrollDecorator { flickableItem: buttons }

//        Flickable {
//            id: buttons
//            anchors.fill: parent
//            contentWidth: column.width
//            contentHeight: column.height
//            clip: true
            Column {
                id: column
                anchors.centerIn: parent
                spacing: 20
            }
//        }
    }

    Rectangle {
        id: title
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
            font.family: "Nokia Pure Text Bold"
            color: "white"
            text: qsTr("Ubuntu Developer Summit")
        }
    }

}
