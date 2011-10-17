import QtQuick 1.0
import com.nokia.symbian 1.0
import "../core"
import "../core/core.js" as Core

Page {
    function save() {
        Core.settings().setValue("lpuser", lpusername.text)
    }

    onStatusChanged: {
        if (status === PageStatus.Deactivating)
            save()
    }

    Flickable {
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

            ListItemText { text: qsTr("Launchpad Username:") }
            TextField {
                id: lpusername
                anchors { left: parent.left; right: parent.right; }
                height: implicitHeight
                inputMethodHints: Qt.ImhPreferLowercase

                Component.onCompleted: text = Core.settings().value("lpuser")
            }
        }
    }
}
