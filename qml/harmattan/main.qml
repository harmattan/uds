/*
    Copyright (C) 2011 Harald Sitter <apachelogger@ubuntu.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import com.ubuntu.summit 1.0
import "../core/core.js" as Core
import "../core/fakelist.js" as FakeList
import "../core/weekday.js" as WeekDay

PageStackWindow {
    id: appWindow

    function onMainEventsChanged() {
        if (pageStack.currentPage.objectName === 'splash')
            pageStack.replace(mainPage)

        mainPage.busy = false
    }

    function onUserEventsChanged() {
        userPage.title = Core.settings().value("lpuser")
    }

    showToolBar: true
    showStatusBar: true
//    initialPage: mainPage

    DayListPage { id: mainPage }
    ListPage { id: userPage; model: userCalendar.sessionModel }

    ToolBarLayout {
        id: commonTools
        visible: false

        ToolIcon {
            enabled: appWindow.pageStack.depth > 1
            platformIconId: "icon-m-toolbar-back".concat(enabled ? "" : "-dimmed")
            onClicked: pageStack.pop()
        }

        ToolIcon {
            enabled: pageStack.currentPage != mainPage
            platformIconId: "icon-m-toolbar-home".concat(enabled ? "" : "-dimmed")
            onClicked: { pageStack.clear(); pageStack.push(mainPage) }
        }
        ToolIcon {
            enabled: pageStack.currentPage != userPage /* || userPage.itemCount <= 0*/
            platformIconId: "icon-m-toolbar-contact".concat(enabled ? "" : "-dimmed")
            onClicked: { pageStack.clear(); pageStack.push(userPage) }
        }
        ToolIcon {
            property bool canCreate: Qt.createComponent("MapPage.qml").createObject(null) !== null
            visible: canCreate
            enabled: pageStack.currentPage.objectName !== "mapPage"
            platformIconId: "icon-m-toolbar-search".concat(enabled ? "" : "-dimmed")
            onClicked: { pageStack.clear(); pageStack.push(Qt.resolvedUrl("MapPage.qml"), {objectName: "mapPage"}) }
        }
        ToolIcon {
            platformIconId: "icon-m-toolbar-settings"
            onClicked: Qt.createComponent("SettingsSheet.qml").createObject(pageStack.currentPage).open()
        }

        ToolIcon {
            platformIconId: "icon-m-toolbar-refresh"
            onClicked: Core.update()
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
            MenuItem { text: qsTr("Clear Cache"); onClicked: Core.clearCache() }
            MenuItem {
                text: qsTr("About")
                enabled: pageStack.currentPage !== null && pageStack.currentPage.objectName !== "aboutPage"
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
                onEnabledChanged: style.textColor = enabled ? "black" : "grey"
            }
        }
    }

    function onMainError(error) {
        var c = Qt.createComponent(Qt.resolvedUrl("InfoBanner.qml"));
        c.createObject(appWindow, { text: qsTr("Main Calendar:") + " " + error }).show()
    }

    function onUserError(error) {
        var c = Qt.createComponent(Qt.resolvedUrl("InfoBanner.qml"));
        c.createObject(appWindow, { text: qsTr("User Calendar:") + " " + error }).show()
    }

    Component.onCompleted: {
        mainCalendar.eventsChanged.connect(onMainEventsChanged)
        userCalendar.eventsChanged.connect(onUserEventsChanged)

        mainCalendar.error.connect(onMainError)
        userCalendar.error.connect(onUserError)

        if (Core.hasCache()) {
            pageStack.push(mainPage)
            Core.updateFromCache();
            Qt.createComponent("../core/UpdateTimer.qml").createObject(appWindow)
            commonTools.visible = true
        } else {
            pageStack.push(Qt.resolvedUrl('SplashPage.qml'), { objectName: 'splash' })
        }
    }
}
