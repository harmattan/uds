import QtQuick 1.1

Row {
    spacing: 5
    property alias lbl: label.text
    property alias txt: txt.text
    Text { id: label; text: qsTr("Summary") }
    Text { id: txt; text: model.modelData.summary }
}