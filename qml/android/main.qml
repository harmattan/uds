import QtQuick 1.0
import "../core"
import "../core/core.js" as Core
import "../core/fakelist.js" as FakeList
import "../core/weekday.js" as WeekDay

Rectangle {
    id: window

    property variant listPages: undefined

//    function initListPages() {
//        var listComponent = Qt.createComponent("ListPage.qml")
//        var buttonComponent = Qt.createComponent("DayButton.qml")

//        for (var i = 0; i < 7; ++i) {
//            var button = buttonComponent.createObject(mainPage.column, {"weekDay": i, "anchors.horizontalCenter": mainPage.column.horizontalCenter})
//            var page = listComponent.createObject(button, { title: WeekDay.numberToString(i)} )

//            page.dayOfWeek = i
//            page.model = mainCalendar.sessionModel

//            FakeList.addItem(page)
//            button.page = page

//        }
//        listPages = FakeList.getList()
//    }

    function onMainEventsChanged() {
//        if (listPages === undefined)
//            initListPages()
        console.debug("fffffff")
        view.model = mainCalendar.sessionModel
    }

//    function onUserEventsChanged() {
//        userPage.title = Qt.createComponent("../core/Settings.qml").createObject(null).value("lpuser")
//    }

    anchors.fill: parent

    ListView {
        id: view
        anchors.fill: parent
        clip: true
//        model: mainCalendar.sessionModel

        delegate: Component {
            Text { height: 72; text: display; font.pixelSize: 32; font.bold: true; verticalAlignment: Text.AlignVCenter }
        }
    }

    Component.onCompleted: {
        mainCalendar.eventsChanged.connect(onMainEventsChanged)
//        userCalendar.eventsChanged.connect(onUserEventsChanged)
//        Core.updateFromCache()
        Core.update()
    }
}
