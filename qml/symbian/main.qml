import QtQuick 1.0
import com.nokia.symbian 1.0
import "../core"
import "../core/core.js" as Core
import "../core/fakelist.js" as FakeList
import "../core/weekday.js" as WeekDay

Window {
    id: window

    property variant listPages: undefined

    function initListPages() {
        var listComponent = Qt.createComponent("ListPage.qml")
        var buttonComponent = Qt.createComponent("DayButton.qml")

        for (var i = 0; i < 7; ++i) {
            var button = buttonComponent.createObject(mainPage.column, {"weekDay": i, "anchors.horizontalCenter": mainPage.column.horizontalCenter})
            var page = listComponent.createObject(button, { title: WeekDay.numberToString(i)} )

            page.dayOfWeek = i
            page.model = mainCalendar.sessionModel

            FakeList.addItem(page)
            button.page = page

        }
        listPages = FakeList.getList()
    }

    function onMainEventsChanged() {
        if (listPages === undefined)
            initListPages()

        mainPage.busy = false
    }

    function onUserEventsChanged() {
        userPage.title = Qt.createComponent("../core/Settings.qml").createObject(null).value("lpuser")
    }

    MainPage { id: mainPage }

    ListPage { id: userPage; model: userCalendar.sessionModel }

    StatusBar {
        id: statusBar
        anchors.top: window.top
    }

    PageStack {
        id: pageStack
        anchors { left: parent.left; right: parent.right; top: statusBar.bottom; bottom: toolBar.top }
    }

    ToolBar {
        id: toolBar
        anchors.bottom: window.bottom
        tools: ToolBarLayout {
            id: toolBarLayout
            ToolButton {
                flat: true
                iconSource: "toolbar-back"
                onClicked: pageStack.depth <= 1 ? Qt.quit() : pageStack.pop()
            }
            ToolButton {
                flat: true
                enabled: !(pageStack.currentPage == mainPage)
                iconSource: "toolbar-home"
                onClicked: { pageStack.clear(); pageStack.push(mainPage) }
            }
            ToolButton {
                flat: true
                enabled: !(pageStack.currentPage == userPage)
                text: "User"
                onClicked: { pageStack.clear(); pageStack.push(userPage) }
            }
            ToolButton {
                flat: true
                iconSource: "toolbar-settings"
                onClicked: Qt.createComponent("SettingsDialog.qml").createObject(pageStack.currentPage).open()
            }
        }
    }

    Component.onCompleted: {
        pageStack.push(mainPage)

        mainCalendar.eventsChanged.connect(onMainEventsChanged)
        userCalendar.eventsChanged.connect(onUserEventsChanged)
        Core.updateFromCache()
        Core.update()
    }
}
