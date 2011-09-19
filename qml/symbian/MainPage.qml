import QtQuick 1.1
import com.nokia.symbian 1.0

Page {
    property alias column: column
    property alias busy: busyIndicator.running

    anchors.fill: parent

    Item {
        anchors.fill: parent

        BusyIndicator {
            id: busyIndicator
            anchors.centerIn: parent
            running: true
            visible: running
        }

        Column {
            id: column
            anchors.centerIn: parent
            spacing: 20
        }
    }
}
