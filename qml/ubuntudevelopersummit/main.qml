import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
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
            var page = listComponent.createObject(button, {title: WeekDay.numberToString(i)})
            FakeList.addItem(page)
            button.page = page
        }
        listPages = FakeList.getList()
    }

    function onItemsChanged(manager) {
        var parser = Qt.createComponent("ICalParser.qml").createObject(null)
        parser.parse(manager)
        var model = parser.ical.events

        var models = new Array(7)
        for (var i = 0; i < models.length; ++i) {
            models[i] = new Array()
        }

        for (var i = 0; i < model.length; ++i) {
            for (var j = 0; j < models.length; ++j) {
                if (model[i].weekDayNumber == j)
                    models[j].push(model[i])
            }
        }

        if (listPages === undefined)
            initListPages()

        for (i = 0; i < listPages.length; ++i) {
            listPages[i].model = models[i]
        }

        mainPage.busy = false
    }

    function onUserItemsChanged(string) {
        console.debug("-----------onUserItemsChanged----------------")
        var parser = Qt.createComponent("ICalParser.qml").createObject(null)
        parser.parse(string)
        var model = parser.ical.events
        userPage.model = model
        userPage.modelSet = true
    }

    function update() {
        var component = Qt.createComponent("Calendar.qml")
        var main = component.createObject(appWindow)
        main.itemsChanged.connect(onItemsChanged)
        main.update("http://summit.ubuntu.com/uds-o.ical")

        var username = Qt.createComponent("Settings.qml").createObject(null).value("lpuser")
        if (username) {
            console.debug(username)
            userPage.title = username
            var user = Qt.createComponent("Calendar.qml").createObject(appWindow)
            user.itemsChanged.connect(onUserItemsChanged)
            user.update("http://summit.ubuntu.com/uds-o/participant/" + username + ".ical")
        } else {
            console.debug("username empty")
        }
    }

    showToolBar: true
    showStatusBar: true
    initialPage: MainPage { id: mainPage }

    UserPage { id: userPage }

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
            enabled: userPage.modelSet && !(pageStack.currentPage == userPage)
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
                property bool isAboutPage: pageStack.currentPage.objectName === "aboutPage"
                text: qsTr("About")
                enabled: pageStack.currentPage.objectName === "aboutPage" ? false: true
                onClicked: pageStack.push(Qt.createComponent("AboutPage.qml"))
                onEnabledChanged: style.textColor = enabled ? "black" : "grey"
            }
        }
    }

    Component.onCompleted: {
        update()
    }
}
