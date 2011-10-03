import QtQuick 1.0

Rectangle {
    id: title

    property alias title: titleText.text
    property alias backgroundColor: color

    height: 72
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
//        color: "#0886CE"
    color: "#E3683D"

    Text {
        id: titleText
        text: WeekDay.numberToString(dayOfWeek)
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 20
        font.pixelSize: 28
        font.family: UI.FONT_FAMILY_BOLD
        color: "white"
    }
}
