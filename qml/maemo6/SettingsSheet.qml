import QtQuick 1.1
import com.nokia.meego 1.0
import "../core"

Sheet {
    acceptButtonText: "Save"
    rejectButtonText: "Cancel"

    content: Flickable {
        id: container
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.topMargin: 10
//        contentWidth: col.width
//        contentHeight: col.height
        flickableDirection: Flickable.VerticalFlick
        Column {
            id: col
            width: parent.width
            spacing: 10

            Label { text: "Settings"; font.bold: true; }

            Label { text: "Launchpad Username:" }
            TextField {
                id: lpusername
                anchors { left: parent.left; right: parent.right; }
                height: implicitHeight
                inputMethodHints: Qt.ImhPreferLowercase

                Component.onCompleted: text = Core.settings().value("lpuser")
            }
        }
    }

    onAccepted: Core.settings().setValue("lpuser", lpusername.text)
}
