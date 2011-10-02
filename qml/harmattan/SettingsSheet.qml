import QtQuick 1.1
import com.nokia.meego 1.0
import "../core/core.js" as Core

Sheet {
    acceptButtonText: qsTr("Save")
    rejectButtonText: qsTr("Cancel")

    content: Flickable {
        id: container
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.topMargin: 10
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: col
            width: parent.width
            spacing: 10

            Label { text: qsTr("Settings"); font.bold: true; }
            Label { text: qsTr("Launchpad Username:") }
            TextField {
                id: lpusername
                anchors { left: parent.left; right: parent.right; }
                height: implicitHeight
                inputMethodHints: Qt.ImhNoAutoUppercase

                Component.onCompleted: text = Core.settings().value("lpuser")
            }
        }
    }

    onAccepted: Core.settings().setValue("lpuser", lpusername.text)
}
