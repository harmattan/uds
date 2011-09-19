import QtQuick 1.0
import com.nokia.symbian 1.0
import com.ubuntu.summit 1.0

Page {
    id: page

    property string title: ''
    property alias dayOfWeek: filtermodel.dateFilter
    property alias model: filtermodel.sourceModel
    property alias itemCount: listview.count

    anchors.fill: parent

    ListView {
        id: listview
        anchors.fill: parent
        anchors.margins: 10
        clip: true

        model: FilterProxyModel { id: filtermodel }

        header: Component {
            id: listHeader

            ListHeading {
                id: listHeading

                ListItemText {
                    id: headingText
                    anchors.fill: listHeading.paddingItem
                    role: "Heading"
                    text: page.title
                }
            }
        }

        delegate: ListItem {
            id: item
            Column {
                anchors.fill: item.padding
                ListItemText {
                    mode: item.mode
                    role: "Title"
                    text: display
                }
                ListItemText {
                    mode: item.mode
                    role: "SubTitle"
                    text: room
                }
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

                pageStack.push(eventPage)
            }
        }
    }

    ScrollDecorator { flickableItem: listview }
}
