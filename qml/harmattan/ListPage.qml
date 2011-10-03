import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import com.ubuntu.summit 1.0
import "constants.js" as UI
import "../core/weekday.js" as WeekDay
import "."

Page {
    property int dayOfWeek
    property alias model: filtermodel.sourceModel

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
            text: WeekDay.numberToString(dayOfWeek)
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 20
            font.pixelSize: 28
            font.family: UI.FONT_FAMILY_BOLD
            color: "white"
        }
    }

    Item {
        anchors.top: title.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        ListView {
            id: listview
            anchors.fill: parent
            anchors.margins: 10
            clip: true

            model: FilterProxyModel { id: filtermodel; dateFilter: dayOfWeek }

            delegate: ListDelegate {
                title: display
                subtitle: room

                Image {
                    source: "image://theme/icon-m-common-drilldown-arrow" + (theme.inverted ? "-inverse" : "")
                    anchors.right: parent.right;
                    anchors.verticalCenter: parent.verticalCenter
                }

                onClicked: {
                    appWindow.pageStack.push(Qt.resolvedUrl("EventPage.qml"),
                                             {
                                                 summary: model.summary,
                                                 dtstart: model.startDateTime,
                                                 dtend: model.endDateTime,
                                                 location: model.location,
                                                 description: model.description,
                                                 track: model.track,
                                                 room: model.room
                                             })
                }
            }
        }

        SectionScroller { listView: listview }
        ScrollDecorator { flickableItem: listview }
    }

    Component.onDestruction: console.debug("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
}
