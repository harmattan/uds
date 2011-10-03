import QtQuick 1.0
import "constants.js" as UI

Rectangle {
    id: title

    property alias title: titleText.text
    property alias backgroundColor: title.color

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
