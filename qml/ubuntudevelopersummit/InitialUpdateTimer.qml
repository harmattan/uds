import QtQuick 1.1

Timer {
    interval: 1000; running: true; repeat: false
    onTriggered: parent.update()
}
