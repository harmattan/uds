import QtQuick 1.0
import QtDesktop 0.1
import com.ubuntu.summit.maemo 5.0
import "../ubuntudevelopersummit"

StackedWindow {
    id: appWindow

    function onUserItemsChanged(string) {
        console.debug("-----------onUserItemsChanged----------------")
        var parser = Qt.createComponent("ICalParser.qml").createObject(null)
        parser.parse(string)
        var model = parser.ical.events
        initialWindow.model = model
    }

    function update() {
        var username = "apachelogger"
        var user = Qt.createComponent("Calendar.qml").createObject(appWindow)
        user.itemsChanged.connect(onUserItemsChanged)
        user.update("http://summit.ubuntu.com/uds-o/participant/" + username + ".ical")
    }

    initialWindow: ListWindow {anchors.fill: parent}

    Component.onCompleted: {
        update()
    }
}
