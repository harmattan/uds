import QtQuick 1.0
import com.nokia.meego 1.0

Page {
    objectName: "aboutPage"
    anchors.fill: parent
    anchors.margins: 32
    tools: commonTools

    // FIXME: utterly broken in landscape

    Column {
        anchors.fill: parent
        spacing: 20

        Item {
            height: column.height + label.height
            anchors.right: parent.right
            anchors.left: parent.left
            Column {
                id: column
                spacing: 5
                Image {
                    id: icon
                    source: "../images/icon.png"
                    anchors.left: parent.left
                }
                Label {
                    anchors.horizontalCenter: icon.horizontalCenter
                    text: "UDS"
                    font.pixelSize: 42
                    font.bold: true
                    font.family: "Nokia Pure Text Bold"
                }
            }

            Label {
                id: label
                text: "12.04"
                font.pixelSize: 32
                font.bold: true
                font.family: "Nokia Pure Text Bold"
                anchors.left: column.right
                anchors.leftMargin: 48
                anchors.verticalCenter: column.verticalCenter
            }
        }

        Image {
            source: "../images/gplv3.png"
        }

        Row {
            anchors.topMargin: 5
            spacing: 5
            width: parent.width

            Label {
                id: copyTag
                text:"©"
            }

            Column {
                width: parent.width - copyTag.width

                Label {
                    id: header
                    text: "2011 Harald Sitter"
                }

                Label {
                    id: content
                    text: "<a href=\"mailto:apachelogger@ubuntu.com\">apachelogger@ubuntu.com</a>"
                    width: parent.width
                    onLinkActivated: Qt.openUrlExternally(link)
                }
            }
        }
    }

}
