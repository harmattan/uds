import QtQuick 1.0
import com.nokia.symbian 1.0
import "../core"

QueryDialog {
    titleText: qsTr("Settings")
    acceptButtonText: qsTr("Save")
    rejectButtonText: qsTr("Cancel")

    content: Flickable {
        id: container
        anchors.fill: parent
        height: 250
        anchors.leftMargin: 10
        anchors.topMargin: 10
        flickableDirection: Flickable.VerticalFlick
        Column {
            id: col
            width: parent.width
            spacing: 10

            ListItemText { text: "Launchpad Username:" }
            TextField {
                id: lpusername
                anchors { left: parent.left; right: parent.right; }
                height: implicitHeight
                inputMethodHints: Qt.ImhPreferLowercase

                Component.onCompleted: text = Qt.createComponent("../core/Settings.qml").createObject(null).value("lpuser")
            }
        }
    }

    onAccepted: {
        Qt.createComponent("../core/Settings.qml").createObject(null).setValue("lpuser", lpusername.text)
    }
}
