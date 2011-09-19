import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import com.ubuntu.summit 1.0
import "../core"
import "../core/core.js" as Core
import "../core/fakelist.js" as FakeList
import "../core/weekday.js" as WeekDay

PageStackWindow {
    id: appWindow

    property variant listPages: undefined

    function initListPages() {
        var listComponent = Qt.createComponent("ListPage.qml")
        var buttonComponent = Qt.createComponent("DayButton.qml")

        for (var i = 0; i < 7; ++i) {
            var button = buttonComponent.createObject(mainPage.column, {"weekDay": i})
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
        userPage.title = Qt.createComponent("Settings.qml").createObject(null).value("lpuser")
    }

    showToolBar: true
    showStatusBar: true
    initialPage: MainPage { id: mainPage }

    ListPage { id: userPage; model: userCalendar.sessionModel }

    InfoBanner {
        id: banner
        anchors.top: parent.top
        anchors.topMargin: 64
    }

    ToolBarLayout {
        id: commonTools
        visible: true
        ToolIcon {
            enabled: appWindow.pageStack.depth > 1
            platformIconId: enabled ? "icon-m-toolbar-back" : "icon-m-toolbar-back-dimmed"
            onClicked: pageStack.pop()
        }

        ToolIcon {
            enabled: !(pageStack.currentPage == initialPage)
            platformIconId: enabled ? "icon-m-toolbar-home" : "icon-m-toolbar-home-dimmed"
            onClicked: { pageStack.clear(); pageStack.push(initialPage) }
        }
        ToolIcon {
            enabled: !(pageStack.currentPage == userPage) && userPage.itemCount > 0
            platformIconId: enabled ? "icon-m-toolbar-contact" : "icon-m-toolbar-contact-dimmed"
            onClicked: { pageStack.clear(); pageStack.push(userPage) }
        }
        ToolIcon {
            platformIconId: "icon-m-toolbar-search"
            onClicked: { pageStack.clear(); pageStack.push(Qt.createComponent("MapPage.qml")) }
        }
        ToolIcon {
            platformIconId: "icon-m-toolbar-settings"
            onClicked: Qt.createComponent("SettingsSheet.qml").createObject(pageStack.currentPage).open()
        }

        ToolIcon {
            platformIconId: "icon-m-toolbar-refresh"
            onClicked: update()
        }
        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem { text: qsTr("Landscape"); onClicked: screen.allowedOrientations = Screen.Landscape }
            MenuItem { text: qsTr("Portrait"); onClicked: screen.allowedOrientations = Screen.Portrait }
            MenuItem {
                text: qsTr("About")
                enabled: pageStack.currentPage !== null && pageStack.currentPage.objectName !== "aboutPage"
                onClicked: pageStack.push(Qt.createComponent("AboutPage.qml"))
                onEnabledChanged: style.textColor = enabled ? "black" : "grey"
            }
        }
    }

    Component.onCompleted: {
        mainCalendar.eventsChanged.connect(onMainEventsChanged)
        userCalendar.eventsChanged.connect(onUserEventsChanged)
        Core.updateFromCache();
        Qt.createComponent("InitialUpdateTimer.qml").createObject(appWindow)
    }
}
