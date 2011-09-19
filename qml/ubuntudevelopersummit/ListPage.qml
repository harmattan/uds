import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import com.ubuntu.summit 1.0
import "constants.js" as UI
import "."

Page {
    property alias title: titleText.text
    property alias dayOfWeek: filtermodel.dateFilter
    property alias model: filtermodel.sourceModel
    property alias itemCount: listview.count

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

        model: FilterProxyModel { id: filtermodel }

        delegate: ListDelegate {
            title: display
            subtitle: room

            Image {
                source: "image://theme/icon-m-common-drilldown-arrow" + (theme.inverted ? "-inverse" : "")
                anchors.right: parent.right;
                anchors.verticalCenter: parent.verticalCenter
            }

            onClicked: {
                console.debug(listview.model)
                var eventPageComponent = Qt.createComponent("EventPage.qml")
                var eventPage = eventPageComponent.createObject(listview)
                eventPage.summary = model.summary
                eventPage.dtstart = model.startDateTime
                eventPage.dtend = model.endDateTime
                eventPage.location = model.location
                eventPage.description = model.description
                eventPage.track = model.track
                eventPage.room = model.room

                appWindow.pageStack.push(eventPage)
            }
        }
    }

    SectionScroller { listView: listview }
    ScrollDecorator { flickableItem: listview }
}
