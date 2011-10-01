import QtQuick 1.0

Rectangle {
    function onItemsChanged(manager) {
        console.debug("SDFSDF")
        parser.parse(manager);
        listview.model = parser.ical.events
    }

    width: 640
    height: 480

    ListView {
        id: listview
        anchors.fill: parent
        anchors.margins: 10

        delegate:
            Row {
            spacing: 10
        }

        onModelChanged: {
            console.debug("nu model")
            console.debug(model.length)
        }
    }

    Component.onCompleted: {
    }
}
