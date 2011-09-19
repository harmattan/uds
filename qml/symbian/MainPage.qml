import QtQuick 1.0
import com.nokia.symbian 1.0

Page {
    id: mainPage

    property alias model: listview.model

    anchors.fill: parent

    ListView {
        id: listview
        anchors.fill: parent
        anchors.margins: 10
        clip: true

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
        }
    }
}
