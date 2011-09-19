import QtQuick 1.0
import com.nokia.meego 1.0
import "../core"

Page {
    id: page

    objectName: "aboutPage"
    anchors.fill: parent
    anchors.margins: 32
    tools: commonTools

    Row {
        id: headerContainer
        spacing: 10
        Image { id: icon; source: "../images/icon.png" }
        Label { anchors.verticalCenter: icon.verticalCenter
            text: "12.04"; font.pixelSize: 32; font.bold: true; font.family: "Nokia Pure Text Bold" }
        Image { anchors.verticalCenter: icon.verticalCenter
            source: "../images/gplv3.png" }
    }

    ListView {
        anchors {
            top: headerContainer.bottom; topMargin: 40;
            bottom: parent.bottom;
            left: parent.left; right: parent.right
        }

        model: AboutModel {}
        delegate: ListDelegate {
            title: "© " + year + " " + name
            subtitle: "<a href=\"mailto:" + mail + "\">" + mail + "</a>"
            onClicked: Qt.openUrlExternally("mailto:" + mail)
        }
    }
}
