import QtQuick 1.0

Item {
    id: window

    property alias pageStack: stack

    PageStack {
        id: stack
        anchors.fill: parent
    }
}
