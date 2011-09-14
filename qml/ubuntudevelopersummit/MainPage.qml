import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    property alias model: listview.model

//    tools: commonTools

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
}
