import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "constants.js" as UI

Page {
    property alias title: titleText.text

    Rectangle {
        id: title
        height: 72
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
//        color: "#0886CE"
        color: "#E3683D"

        Text {
            id: titleText
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 20
            font.pixelSize: 28
            font.family: UI.FONT_FAMILY_BOLD
            color: "white"
        }
    }
}
