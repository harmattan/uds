import QtQuick 1.0
import "../ubuntudevelopersummit"

Rectangle {
    function onItemsChanged(manager) {
        console.debug("SDFSDF")
        parser.parse(manager);
        listview.model = parser.ical.events
    }

    width: 640
    height: 480

    ICalParser { id: parser }

    ListView {
        id: listview
        anchors.fill: parent
        anchors.margins: 10

        delegate:
            Row {
            spacing: 10
            LabelRow { lbl: "Summary"; txt: model.modelData.summary }
            LabelRow { lbl: "Start"; txt: model.modelData.start }
            LabelRow { lbl: "End"; txt: model.modelData.end }
            LabelRow { lbl: "Room"; txt: model.modelData.x_roomname }
        }

        onModelChanged: {
            console.debug("nu model")
            console.debug(model.length)
        }
    }

    Component.onCompleted: {
        remoteManager.itemsChanged.connect(onItemsChanged)
        remoteManager.update()
    }
}
