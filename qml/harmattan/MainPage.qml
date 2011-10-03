import QtQuick 1.1
import com.nokia.meego 1.0
import "../core/weekday.js" as WeekDay

Page {
    id: page

    property alias busy: busyIndicator.running
    property alias model: listview.model

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

        ListView {
            id: listview

            /** @returns name of day with first character having bigger font size */
            function formattedTitle(dayOfWeek, baseSize) {
                var name = WeekDay.numberToString(dayOfWeek)
                var firstChar = name.charAt(0)
                var rest = name.substr(1)
                return '<font size="' + baseSize * 1.5 + '">' + firstChar + '</font>' + rest
            }

            model: ListModel {}
            anchors.fill: parent
            anchors.margins: 10
            clip: true

            delegate: ListDelegate {
                title: listview.formattedTitle(dayOfWeek, titleSize)
                onClicked: pageStack.push(Qt.resolvedUrl("ListPage.qml"),
                                          { dayOfWeek: dayOfWeek, model: mainCalendar.sessionModel })

                Image {
                    source: "image://theme/icon-m-common-drilldown-arrow" + (theme.inverted ? "-inverse" : "")
                    anchors.right: parent.right;
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    PageHeader { title: qsTr("Ubuntu Developer Summit") }
}
