import QtQuick 1.0
import QtDesktop 0.1
import com.ubuntu.summit.maemo 5.0

Window {
    property alias model: view.model

    title: "All Sessions"

    SystemPalette { id: systemPalette; colorGroup: SystemPalette.Disabled }

    ListView {
        id: view
        anchors.fill: parent
        anchors.margins: 20
        clip: true

        delegate: Item {
            height: 70
            anchors { left: parent.left; right: parent.right }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                color: systemPalette.text
                text: model.modelData.summary
                height: 32
            }
            Rectangle {
                anchors.bottom: parent.bottom
                height: 1
                width: parent.width - 10
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#002439"
            }
        }
    }
}
