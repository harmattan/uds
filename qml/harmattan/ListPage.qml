import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import com.ubuntu.summit 1.0
import "constants.js" as UI
import "../core/weekday.js" as WeekDay
import "."

Page {
    property int dayOfWeek: -1
    property alias model: filtermodel.sourceModel

    anchors.fill: parent
    tools: commonTools

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

    PageHeader { title: WeekDay.numberToString(dayOfWeek) }
}
