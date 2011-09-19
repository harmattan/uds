import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import com.ubuntu.summit 1.0
import "WeekDay.js" as WeekDay
import "script.js" as FakeList

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

    function onEventsChanged() {
        console.debug("hooooo")
        if (listPages === undefined)
            initListPages()

        mainPage.busy = false
        console.debug("SFSDFSDFSDFSDRFSDFSDF")
    }

    function update() {
        console.debug("UPDATE!!$!!#@%$!%!%!%!%")
        mainCalendar.eventsChanged.connect(onEventsChanged)
        mainCalendar.update("http://summit.ubuntu.com/uds-o.ical")

        var username = Qt.createComponent("Settings.qml").createObject(null).value("lpuser")
        if (username) {
            console.debug(username)
            userPage.title = username
            userCalendar.update("http://summit.ubuntu.com/uds-o/participant/" + username + ".ical")
        } else {
            console.debug("username empty")
        }
    }

    function updateFromCache() {
        mainCalendar.eventsChanged.connect(onEventsChanged)
        mainCalendar.updateFromCache("http://summit.ubuntu.com/uds-o.ical")

        var username = Qt.createComponent("Settings.qml").createObject(null).value("lpuser")
        if (username) {
            console.debug(username)
            userPage.title = username
            userCalendar.updateFromCache("http://summit.ubuntu.com/uds-o/participant/" + username + ".ical")
        } else {
            console.debug("username empty")
        }
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
//            enabled: appWindow.pa
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
                property bool isAboutPage: pageStack.currentPage !== null && pageStack.currentPage.objectName === "aboutPage"
                text: qsTr("About")
                enabled: isAboutPage
                onClicked: pageStack.push(Qt.createComponent("AboutPage.qml"))
                onEnabledChanged: style.textColor = enabled ? "black" : "grey"
            }
        }
    }

    Component.onCompleted: {
//        updateFromCache();
        Qt.createComponent("InitialUpdateTimer.qml").createObject(appWindow)
    }
}
