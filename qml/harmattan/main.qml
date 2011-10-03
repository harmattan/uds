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

    property bool initialized: false

    function init() {
        for (var i = 0; i < 7; ++i) {
            mainPage.model.append({"dayOfWeek": i})
        }
        initialized = true
    }

    function onMainEventsChanged() {
        if (!initialized)
            init()

        mainPage.busy = false
    }

    function onUserEventsChanged() {
        userPage.title = Core.settings().value("lpuser")
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
//            enabled: !(pageStack.currentPage == userPage) && userPage.itemCount > 0
            platformIconId: enabled ? "icon-m-toolbar-contact" : "icon-m-toolbar-contact-dimmed"
            onClicked: { pageStack.clear(); pageStack.push(userPage) }
        }
        ToolIcon {
            platformIconId: "icon-m-toolbar-search"
            onClicked: { pageStack.clear(); pageStack.push(Qt.resolvedUrl("MapPage.qml")) }
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
            MenuItem {
                text: qsTr("About")
                enabled: pageStack.currentPage !== null && pageStack.currentPage.objectName !== "aboutPage"
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
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
