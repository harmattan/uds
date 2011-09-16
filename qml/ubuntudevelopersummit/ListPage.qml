import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "constants.js" as UI
import "."

Page {
    property alias title: titleText.text
    property alias model: listview.model

    anchors.fill: parent
    tools: commonTools

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
            font.family: UI.FONT_FAMILY_BOLD
            color: "white"
        }
    }

    ListView {
        id: listview
        anchors.top: title.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        anchors.margins: 10
        clip: true

        delegate: ListDelegate {
            title: model.modelData.summary
            subtitle: model.modelData.x_roomname

            Image {
                source: "image://theme/icon-m-common-drilldown-arrow" + (theme.inverted ? "-inverse" : "")
                anchors.right: parent.right;
                anchors.verticalCenter: parent.verticalCenter
            }

            onClicked: {
                var eventPageComponent = Qt.createComponent("EventPage.qml")
                var eventPage = eventPageComponent.createObject(listview, { "event": model.modelData })
                appWindow.pageStack.push(eventPage)
            }
        }
    }

    SectionScroller { listView: listview }
    ScrollDecorator { flickableItem: listview }
}
