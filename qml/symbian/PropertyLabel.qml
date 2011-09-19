import QtQuick 1.0
import com.nokia.symbian 1.0

Row {
    id: row

    property alias label: label.text
    property alias value: value.text

    spacing: 10

    ListItemText { id: label; font.bold: true }
    ListItemText {
        id: value;
        anchors.bottom: parent.bottom
        wrapMode: Text.Wrap
//        FIXME: needs width, but width is bottom up, rather than top down :(
//        width:
    }
}
