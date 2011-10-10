import QtQuick 1.1
import com.nokia.symbian 1.0
import "../core"

Page {
    property alias busy: busyIndicator.running

    Item {
        anchors.fill: parent

        ListView {
            clip: true
            anchors.fill: parent
            visible: !busyIndicator.visible
            model: DayListModel{}
            delegate: ListItem {
                subItemIndicator: true
                ListItemText { text: name }
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("ListPage.qml"),
                                   {
                                       title: name,
                                       dayOfWeek: number,
                                       model: mainCalendar.sessionModel
                                   })
                }
            }
        }

        BusyIndicator {
            id: busyIndicator
            anchors.centerIn: parent
            running: true
            visible: running
        }
    }
}
